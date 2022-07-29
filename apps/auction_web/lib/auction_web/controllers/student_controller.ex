defmodule AuctionWeb.StudentController do
  use AuctionWeb, :controller
  alias Auction.Student
 # require IEx
  #import Auction.Student
  plug :put_layout, {AuctionWeb.LayoutView, "showstudent.html"}

  #plug :prevent_unauthorized_access when action in [:show]


 #@profile_map = %{title: title, lastname: lastname, firstname: firstname, spousename: spousename, streetaddress: streetaddress, city: city,
                   #state: state, zipcode: zipcode, phoneone: phoneone, phonetwo: phonetwo}

  def index(conn, _params) do
    current_user = Map.get(conn.assigns, :current_user)
    userid=current_user.id                             # a user has id - students  include user_id
    lastname = Auction.get_user_lastname(userid)
    students = Auction.show_students(userid)     # students is a map  auction.User - it includes a LIST of student maps
    # We need a list of changesets
    # The assigns variable, (3r'd parameter of render), is a map - the map symbols are optional - but I don't like ambiguity
    # In index.html - @students will equate to value of studentinfo,students - @lastname to value of last_name
    # In the index template, @students is a sort of alias for students: which is a list of student
    conn
      |> assign(:student_id, userid)
      |> assign(:students,   students)
      |> assign(:lastname,   lastname)
      |> render("index.html", layout: {AuctionWeb.LayoutView, "indexstudent.html"})
    #render(conn, "index.html", %{students: students ,lastname: lastname})
     #layout: {AuctionWeb.LayoutView, "indexstudent.html"})
  end

  ##############################################################
  # student is a changeset - student.data is a schema struct   #
  # Obtained student_id from the id: field in the struct       #
  # What did we  request ?  id param must include key "id"     #
  # Suppose no id was supplied or perhaps user_id was supplied #
  # %{"id" => id} pattern match - id must match string "id"    #
  ##############################################################
  def show(conn, %{"id" => id}) do
    IO.puts("SHOW ID")
    IO.inspect(id)
    current_user =    Map.get(conn.assigns, :current_user)
    userid=current_user.id
    lastname =        Auction.get_user_lastname(userid)
    student =         Auction.show_student(id)   #student is a changeset
    student_id =      student.data.id         # actual id in student table
    reg_list =        Auction.get_registration_by_one(student_id)
    reg_map =         Enum.at(reg_list,0)
    registration_id = reg_map.id
    |> IO.inspect()
    IO.puts("reg id")
    # assign student to @student and student_id to @student_id and lastname to @lastname
    conn
    |> assign(:student, student)
    |> assign(:student_id, student_id)
    |> assign(:lastname, lastname)
    |> assign(:registration_id, registration_id)
    |> render("show.html", layout: {AuctionWeb.LayoutView, "showstudent.html"})
    #render(conn, "show.html", %{student: student, student_id: student_id, lastname: lastname,
    #  layout: {AuctionWeb.LayoutView, "showstudent.html"}})  # use a different layout than app
  end

  def new(conn, _params) do  # conn - a plug containing request and response information.
    student = Auction.new_student()
    render(conn, "new.html", student: student)#, conn: conn)
  end

  ######################################################################
  # student is a changeset - student.data is a schema struct           #
  # What did we  request ?  student_params must include key "student"  #
  # student_params may, however, include other keys                    #
  ######################################################################
  def create(conn, %{"student" => student_params}) do
    # get current_user
    # from a Map - get the value for a key - in this case from conn.assigns
    current_user = Map.get(conn.assigns, :current_user)
    # get current_user.id
    userid=current_user.id
    # insert user :id into student :user_id
    # The Map.put/3 function takes three arguments: a map, a key and a value.
    # It will then return an updated version of the original map.
    studentparams = Map.put(student_params, "user_id", userid)
    #%Student{}#Auction.Student


    stuff = Student.changeset(%Student{}, studentparams)
    #stuff = assign(stuff, :action, Routes.student_path(conn, :show))

    case stuff do #Auction.insert_student(studentparams) do
      {:ok, student}    -> redirect(conn, to: Routes.student_path(conn, :show, student))
      {:error, student} -> render(conn, "new.html", student: student)
    end
  end

  #######################################################################
  # pattern match on key  labeled "id"                                  #
  # Note. The fat arrow designates a key => value pair within a map.    #
  # where the name of the map is assigned to the variable placeholder x #
  #######################################################################
  def edit(conn, %{"id" => id}) do #
    current_user = Map.get(conn.assigns, :current_user)
    # get user id - links to user table
    userid=current_user.id
    student = Auction.show_student(id)    # get student changeset by student.id  - firstname, grade, birthday
    student_id = student.data.id
    firstname = student.data.firstname
    # lastname is contained in profile belonging to user
    lastname = Auction.get_user_lastname(userid)
    #lastname = lastname.data.lastname
    render(conn, "edit.html", student: student, conn: conn, firstname: firstname, lastname: lastname, student_id: student_id,
      layout: {AuctionWeb.LayoutView, "editstudent.html"})
  end

  def update(conn, student_params) do
    current_user = Map.get(conn.assigns, :current_user)
    userid=current_user.id
    student = Auction.get_student(userid)
    student_id = student.data.id
    IO.puts("inspect student id")
    IO.inspect(student_id)
    firstname = student.data.firstname
    lastname = Auction.get_student_profile(userid)
    lastname = lastname.data.lastname
    #params = Auction.Student.changeset(student_params)
    case Auction.update_student(student, student_params) do
      {:ok, student} -> redirect(conn, to: Routes.student_path(conn, :show, student))
      {:error, student} -> render(conn, "edit.html", student: student, conn: conn, firstname: firstname, lastname: lastname, student_id: student_id,
        layout: {AuctionWeb.LayoutView, "editstudent.html"})
    end
  end

  # Pattern match to determine that there is no current user
  defp require_logged_in_user(%{assigns: %{current_user: nil}} = conn, _opts) do
    conn
    |> put_flash(:error, "You must be logged in to create a student.")
    |> redirect(to: Routes.profile_path(conn, :show))
    |> halt()
    end

    # Pass on the conn because there is a current user
    defp require_logged_in_user(conn, _opts), do: conn

end

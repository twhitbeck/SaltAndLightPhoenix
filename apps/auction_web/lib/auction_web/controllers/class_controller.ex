defmodule AuctionWeb.ClassController do
  use AuctionWeb, :controller

  alias Auction.Class
  # import Auction.Student

  plug :require_logged_in_user

  # conn - a plug containing request and response information.
  def new(conn, _params) do
    class = Auction.new_class()
    # , conn: conn)
    render(conn, "new.html", class: class)
  end

  def create(conn, %{"class" => class_params}) do
    # get current_user
    current_user = Map.get(conn.assigns, :current_user)
    # get current_user.id
    userid = current_user.id
    # insert user :id into student :user_id
    classparams = Map.put(class_params, "user_id", userid)
    # %Student{}#Auction.Student
    stuff = Class.changeset(%Class{}, classparams)
    # stuff = assign(stuff, :action, Routes.student_path(conn, :show))

    # Auction.insert_student(studentparams) do
    case stuff do
      {:ok, class} -> redirect(conn, to: Routes.class_path(conn, :show, class))
      {:error, class} -> render(conn, "new.html", class: class)
    end
  end

  def index(conn, %{"classtitle_id" => classtitle_id}) do
    IO.puts("MADE IT TO INDEX")
    class = Auction.get_class_from_title(classtitle_id)
    # function x
    classes = Enum.map(class, fn x -> package_classes_data(classtitle_id) end)

    classtitle_list = Auction.get_classtitles()
    # show_classes needs fixed
    # students = Auction.show_classes(userid).classes #students is a list of structs
    # render(conn, "index.html", students: students ,lastname: last_name,##
    # layout: {AuctionWeb.LayoutView, "indexstudent.html"})
  end

  def package_classes_data(classtitle_id) do
    # classdata =       Auction.get_class_from_classid(classid)
    # classtitle =      regdata.classtitle.description
    # fallfee =         regdata.fallfee
    # springfee =       regdata.springfee
    # fee =             Auction.get_fee(semester, fallfee, springfee)
    # section =         regdata.section.description
    # period =          regdata.period.time
    # teachername =     Auction.get_teacher_name(regdata.teacher.id)
    # helper1name =     Auction.get_teacher_name(regdata.helper1.id)
    # helper2name =     Auction.get_teacher_name(regdata.helper2.id)
    # list = [classtitle,section,period,fee,semester,teachername,helper1name,helper2name]
  end

  #########################
  #  id is a classtitle   #
  #########################
  def show(conn, %{"id" => id} = _params) do
    # def get_class_from_title(id) do
    # changeset
    classtitle = Auction.get_class_title(id)

    IO.puts("CLASS LIST")

    classlist = Auction.get_class_from_title(id)
    classes = Enum.map(classlist, fn x -> Auction.list_class_data(x.id, x.semester) end)
    IO.inspect(classes)
    IO.puts("SHOW CLASS CONTROLLER")
    # IO.inspect(classtitle.description)
    # IO.inspect(classes)
    # use a different layout than app
    conn
    # Ex: "Early American History"
    |> assign(:title, classtitle.description)
    |> assign(:classes, classes)
    |> render("show.html")
  end

  # _ \\ %{}) do #%{"id" => id}) do #%{"id" => id}) do
  def edit(conn, %{"id" => id}) do
    IO.puts("EDIT CLASS ID")
    IO.inspect(id)
    current_user = Map.get(conn.assigns, :current_user)
    # get user id - links to user table
    userid = current_user.id
    # get student changeset by student.id  - firstname, grade, birthday
    class = Auction.show_class(id)
    class_id = class.data.id
    # firstname = student.data.firstname
    # lastname is contained in profile belonging to user
    # lastname = Auction.get_student_profile(userid)
    # lastname = lastname.data.lastname
    render(conn, "edit.html",
      class: class,
      conn: conn,
      class_id: class_id,
      layout: {AuctionWeb.LayoutView, "editclass.html"}
    )
  end

  def update(conn, student_params) do
    current_user = Map.get(conn.assigns, :current_user)
    userid = current_user.id
    student = Auction.get_student(userid)
    student_id = student.data.id
    IO.puts("inspect student id")
    IO.inspect(student_id)
    firstname = student.data.firstname
    lastname = Auction.get_student_profile(userid)
    lastname = lastname.data.lastname
    # params = Auction.Student.changeset(student_params)
    case Auction.update_student(student, student_params) do
      {:ok, student} ->
        redirect(conn, to: Routes.student_path(conn, :show, student))

      {:error, student} ->
        render(conn, "edit.html",
          student: student,
          conn: conn,
          firstname: firstname,
          lastname: lastname,
          student_id: student_id,
          layout: {AuctionWeb.LayoutView, "editstudent.html"}
        )
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

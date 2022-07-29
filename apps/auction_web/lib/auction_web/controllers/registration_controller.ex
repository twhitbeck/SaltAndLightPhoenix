defmodule AuctionWeb.RegistrationController do
  use AuctionWeb, :controller
  alias Auction.Registration
  #import Auction.Student

  plug :require_logged_in_user


  ######################################################################
  # registration is a changeset - registration.data is a schema struct #
  # Obtained registration_id from the id: field in the struct          #
  ######################################################################
  def new(conn, _params) do  # conn - a plug containing request and response information.
    registration = Auction.new_registration()
    render(conn, "new.html", registration: registration)#, conn: conn)
  end

  #######################################################################
  # Note. The fat arrow designates a key => value pair within a map.    #
  # where the name of the map is assigned to the variable placeholder x #
  #######################################################################
  def create(conn, %{"registration" => registration_params}) do
    # get current_user
    current_user = Map.get(conn.assigns, :current_user)
    # get current_user.id
    userid=current_user.id
    # insert user :id into student :user_id
    registrationparams = Map.put(registration_params, "user_id", userid)
    #%Student{}#Auction.Student
    stuff = Registration.changeset(%Registration{}, registrationparams)
    #stuff = assign(stuff, :action, Routes.student_path(conn, :show))
    case stuff do #Auction.insert_student(studentparams) do
      {:ok, registration}    -> redirect(conn, to: Routes.registration_path(conn, :show, registration))
      {:error, registration} -> render(conn, "new.html", registration: registration)
    end
  end

  def index(conn,  %{"student_id" => student_id}) do # student id
    IO.puts("Registration Index")
    firstname = Auction.get_student(student_id).firstname
    current_user = Map.get(conn.assigns, :current_user)
    userid=current_user.id
    lastname = Auction.get_user_lastname(userid)
    # regs.id is registration id, regs.class_id exists also
    regs = Auction.get_student_registrations(student_id)
    ##################################
    # classes is a list of class ids #
    ##################################
    classes = Enum.map(regs, fn x -> package_registration_data(x.class_id, x.semester)  end)
    |> IO.inspect()
    #Auction.testlist(classes)
    #[
    #  ["Sr Drama", "10-12", "1:00 PM", "fee unknown", 1, "Daniel Sullivan",
    #   "Jessica Ward", "Ami Bondi"],

    #  ["Gym", "1-2", "12:00 PM", "fee unknown", 1, "Vanessa Campbell",
    #   "Helen Lorah", "Elyse Stobart"]
    #]
    IO.puts("Check INDESX")
    conn
    |> assign(:student_name,  firstname)
      |> assign(:firstname,  firstname)
      |> assign(:lastname,   lastname)
      |> assign(:classes,    classes)
      |> render("index.html") # , layout: {AuctionWeb.LayoutView, "indexstudent.html"})
    #render(conn, "index.html", %{students: students ,lastname: lastname})
     #layout: {AuctionWeb.LayoutView, "indexstudent.html"})
  end

  def package_registration_data(classid, semester) do
    IO.inspect(classid)
    regdata =         Auction.get_class_from_classid(classid)
    classtitle =      regdata.classtitle.description
    fallfee =         regdata.fallfee
    springfee =       regdata.springfee
    fee =             Auction.get_fee(semester, fallfee, springfee)
    section =         regdata.section.description
    period =          regdata.period.time
    teachername =     Auction.get_teacher_name(regdata.teacher.id)
    helper1name =     Auction.get_teacher_name(regdata.helper1.id)
    helper2name =     Auction.get_teacher_name(regdata.helper2.id)
    list = [classtitle,section,period,fee,semester,teachername,helper1name,helper2name]
  end

  def show(conn, %{"id" => id}) do  # registration id
    IO.puts("SHOW ID")
      student_id =      Auction.get_student_id_from_registration(id)
      regdata =         Auction.get_class_from_registration(id)
      |> IO.inspect()
      reg_list =        Auction.get_registration_by_one(id)
      reg_map =         Enum.at(reg_list,0)
      registration_id = reg_map.id
      |> IO.inspect()
      IO.puts("reg id")
      classtitle =      regdata.class.classtitle.description
      semester =        regdata.semester
      fallfee =         regdata.class.fallfee
      springfee =       regdata.class.springfee
      fee =             Auction.get_fee(semester, fallfee, springfee)
      section =         regdata.class.section.description
      period =          regdata.class.period.time
      teachername =     Auction.get_teacher_name(regdata.class.teacher.id)
      helper1name =     Auction.get_teacher_name(regdata.class.helper1.id)
      helper2name =     Auction.get_teacher_name(regdata.class.helper2.id)

      current_user = Map.get(conn.assigns, :current_user)
      userid=current_user.id
      lastname = Auction.get_user_lastname(userid)
      student = Auction.show_student(student_id)   # student is a changeset
      IO.inspect(student.data)
      firstname = student.data.firstname
      student_name = Enum.join([firstname, lastname], " ")

        # assign student to @student and student_id to @student_id and lastname to @lastname
      conn
      |> assign(:student_name,    student_name)
      |> assign(:student,         student)
      |> assign(:student_id,      student_id)
      |> assign(:registration_id, registration_id)
      |> assign(:classtitle,      classtitle)
      |> assign(:semester,        semester)
      |> assign(:section,         section)
      |> assign(:period,          period)
      |> assign(:fee,             fee)


      |> render("show.html", layout: {AuctionWeb.LayoutView, "showstudent.html"})
      #render(conn, "show.html", %{student: student, student_id: student_id, lastname: lastname,
      #  layout: {AuctionWeb.LayoutView, "showstudent.html"}})  # use a different layout than app
    end




  ############################################################
  # student is a changeset - student.data is a schema struct #
  # Obtained student_id from the id: field in the struct     #
  ############################################################
  def show(conn, %{"id" => id}) do
    IO.puts("SHOW ID")
    IO.inspect(id)
    current_user = Map.get(conn.assigns, :current_user)
    userid=current_user.id
    lastname = Auction.get_user_lastname(userid)
    student = Auction.show_student(id)   #student is a changeset
    |> IO.inspect()
    student_id = student.data.id         # actual id in student table
    # assign student to @student and student_id to @student_id and lastname to @lastname
    conn
    |> assign(:student, student)
    |> assign(:student_id, student_id)
    |> assign(:lastname, lastname)
    |> render("show.html", layout: {AuctionWeb.LayoutView, "showstudent.html"})
    #render(conn, "show.html", %{student: student, student_id: student_id, lastname: lastname,
    #  layout: {AuctionWeb.LayoutView, "showstudent.html"}})  # use a different layout than app
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

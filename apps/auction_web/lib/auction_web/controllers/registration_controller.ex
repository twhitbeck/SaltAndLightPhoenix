defmodule AuctionWeb.RegistrationController do
  use AuctionWeb, :controller
  # import Auction.Student

  plug(:require_logged_in_user)

  ######################################################################
  # registration is a changeset - registration.data is a schema struct #
  # Obtained registration_id from the id: field in the struct          #
  ######################################################################
  # conn - a plug containing request and response information.
  def new(conn, _params) do
    registration = Auction.new_registration()
    # , conn: conn)
    render(conn, "new.html", registration: registration)
  end

  #######################################################################
  # Note. The fat arrow designates a key => value pair within a map.    #
  # where the name of the map is assigned to the variable placeholder   #
  # Create - recieve the parameters needed for one new registration     #
  #  and then saves the registration to the data store.                 #
  # Need only - (1) student_id, (2) class_id                            #
  #######################################################################
  def create(conn, %{"registration" => registration_params}) do
    IO.puts("Create registration")
    IO.inspect(registration_params)

    case Auction.create_registration(registration_params) do
      {:ok, registration} ->
        conn
        |> put_flash(:info, "Registration created successfully.")
        |> redirect(to: Routes.student_registration_path(conn, :index, registration))

      {:error, registration} ->
        render(conn, "new.html", registration: registration)
    end
  end

  ########################################################
  # list registrations for student - input as student_id #
  ########################################################
  # student id
  def index(conn, %{"student_id" => student_id} = params) do
    IO.puts("Registration Controller Index function")
    # EX: %{"classtitle" => "Chess & Games", "student_id" => "30"}
    firstname = Auction.get_student(student_id).firstname
    current_user = Map.get(conn.assigns, :current_user)
    userid = current_user.id
    lastname = Auction.get_user_lastname(userid)
    # regs.id is registration id, regs.class_id exists also
    regs = Auction.get_student_registrations(student_id)
    ##################################
    # classes is a list of class ids #
    # One list of lists              #
    ##################################
    classes = Enum.map(regs, fn x -> Auction.list_class_data(x.class_id, x.semester) end)
    # |> IO.inspect()

    # Auction.testlist(classes)
    # [
    #  ["Sr Drama", "10-12", "1:00 PM", "fee unknown", 1, "Daniel Sullivan",
    #   "Jessica Ward", "Ami Bondi"],

    #  ["Gym", "1-2", "12:00 PM", "fee unknown", 1, "Vanessa Campbell",
    #   "Helen Lorah", "Elyse Stobart"]
    # ]
    classtitle = params["classtitle"]
    # |> IO.inspect()

    classtitlelist = Auction.get_classtitles()
    # |> IO.inspect()

    conn
    |> assign(:class_params, params)
    |> assign(:titlelist, classtitlelist)
    |> assign(:student_id, student_id)
    |> assign(:firstname, firstname)
    |> assign(:lastname, lastname)
    |> assign(:classes, classes)
    # , layout: {AuctionWeb.LayoutView, "indexstudent.html"})
    |> render("index.html")

    # render(conn, "index.html", %{students: students ,lastname: lastname})
    # layout: {AuctionWeb.LayoutView, "indexstudent.html"})
  end

  # registration id
  def show(conn, %{"id" => id}) do
    IO.puts("SHOW ID")
    student_id = Auction.get_student_id_from_registration(id)

    regdata =
      Auction.get_class_from_registration(id)
      |> IO.inspect()

    reg_list = Auction.get_registration_by_one(id)
    reg_map = Enum.at(reg_list, 0)

    registration_id = reg_map.id
    # |> IO.inspect()

    IO.puts("reg id")
    classtitle = regdata.class.classtitle.description
    semester = regdata.semester
    fallfee = regdata.class.fallfee
    springfee = regdata.class.springfee
    fee = Auction.get_fee(semester, fallfee, springfee)
    section = regdata.class.section.description
    period = regdata.class.period.time
    teachername = Auction.get_teacher_name(regdata.class.teacher.id)
    helper1name = Auction.get_teacher_name(regdata.class.helper1.id)
    helper2name = Auction.get_teacher_name(regdata.class.helper2.id)

    current_user = Map.get(conn.assigns, :current_user)
    userid = current_user.id
    lastname = Auction.get_user_lastname(userid)
    # student is a changeset
    student = Auction.show_student(student_id)
    IO.inspect(student.data)
    firstname = student.data.firstname
    student_name = Enum.join([firstname, lastname], " ")

    # assign student to @student and student_id to @student_id and lastname to @lastname
    conn
    |> assign(:student_name, student_name)
    |> assign(:student, student)
    |> assign(:student_id, student_id)
    |> assign(:registration_id, registration_id)
    |> assign(:classtitle, classtitle)
    |> assign(:semester, semester)
    |> assign(:section, section)
    |> assign(:period, period)
    |> assign(:fee, fee)
    |> render("show.html", layout: {AuctionWeb.LayoutView, "showstudent.html"})

    # render(conn, "show.html", %{student: student, student_id: student_id, lastname: lastname,
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
    userid = current_user.id
    lastname = Auction.get_user_lastname(userid)
    # student is a changeset
    student =
      Auction.show_student(id)
      |> IO.inspect()

    # actual id in student table
    student_id = student.data.id
    # assign student to @student and student_id to @student_id and lastname to @lastname
    conn
    |> assign(:student, student)
    |> assign(:student_id, student_id)
    |> assign(:lastname, lastname)
    |> render("show.html", layout: {AuctionWeb.LayoutView, "showstudent.html"})

    # render(conn, "show.html", %{student: student, student_id: student_id, lastname: lastname,
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

defmodule AuctionWeb.RegistrationController do
  use AuctionWeb, :controller
  # import Auction.Student

  plug(:require_logged_in_user)

  alias Auction.{
    Registration,
    Repo
  }

  ####################################################################################
  #                        1. Rendering - maps and lists                             #
  #                            Render from a view                                    #
  # three parameters associated with the render:                                     #
  # the View, the Template, and the “assigns”. The view may be implied.              #
  # Rendering the default view render("index.html", name: "Wintermute")              #
  # Specifying the VIEW render(SprawlWeb.PageView, "index.html", name: "Wintermute") #
  # The last parameter is the “assigns” Map                                          #
  # render("show.html", %{id: 2112, name: "Wintermute"})                             #
  # view's version of render - must manually assign the conn and the file type       #
  # must be specified.                                                               #
  #                                                                                  #
  #                          2. render from a controller                             #
  # %Plug.Conn{} struct plays a significant role. Because of that, the conn variable #
  # needs to be provided to the render/n function.                                   #
  # controller’s version of render sets the conn value in the assigns                #
  # render conn, :index, users: list_of_users or to a differnt view:                 #
  # conn                                                                             #
  #   |> put_view(SprawlWeb.UserView)                                                #
  #   |> render :show, name: "Maelcum", title: "Pilot" - let's use map symbols tho   #
  #                                                                                  #
  #                          3. render from a template                               #
  # render/2 - defaults to current view -- render/3 specifies the view               #
  # <%= render "show.html", name: "Case", occupation: "Hacker" %> (2 parameters)     #
  # <%= render SprawlWeb.SharedView, "sidebar.html", ai_list: ais %> (3 parameters)  #
  # NOTE: can render lists as well as maps                                           #
  # https://samuelmullen.com/articles/phoenix_templates_rendering_and_layouts/       #
  ####################################################################################

  ######################################################################
  #                             ASSIGNS       - lives in conn          #
  # @ is a macro that essentially calls                                #
  # Map.get to get our given key in the template assigns.              #
  ######################################################################

  ######################################################################
  # registration is a changeset - registration.data is a schema struct #
  # Obtained registration_id from the id: field in the struct          #
  # map construction 1. %{"student_id" => "30}                         #
  # 2. %{student_id: "30}    - not garbase collected                   #
  # 3. %{student_id: => "30} - similar to 1.                           #
  ######################################################################
  # conn - a plug containing request and response information.
  def new(conn, _params) do
    IO.puts("new registration")
    changeset = Registration.changeset(%Registration{})
    # render(conn, "new.html", changeset: changeset)

    # atom_params =
    #  Auction.key_to_atom(params)
    #  |> IO.inspect()

    # student_id = atom_params[:student_id]

    # Registration is aliased to Auction.Registration
    map = %{class_id: "5", semester: "1", student_id: "30"}

    registration = Auction.Registration.changeset(%Registration{}, map)

    # IO.inspect(map)
    # %{student_id : 30}

    # ex: %{"student_id" => "30"}
    #
    # a blank changeset obtained thru auction.ex - auction/registration.ex
    # registration = Auction.new_registration(params)
    # O.inspect(student_id)
    I
    # IO.inspect(firstname)
    # IO.inspect(lastname)
    # IO.inspect(registration)

    # conn
    # |> assign(:student_id, student_id)
    # |> assign(:firstname, firstname)
    # |> assign(:lastname, lastname)

    render(conn, "new.html",
      registration: registration
      # firstname: firstname,
      # lastname: lastname,
      # student_id: student_id
    )
  end

  #################################################################################################################################
  # The first detail we’ll look at in show/2 is the function definition: def show(conn, %{"id" ⇒ id}) do.                         #
  # We can see that show is going to be passed two parameters, conn and a Map.                                                    #
  # Every function in the controller expects the same by default: a conn and a Map.                                               #
  # The Map is actually a Map of the request parameters from the user.                                                            #
  # While there could be a large number of parameters that get passed into the request by the site visitor,                       #
  # the only one we care about in show is the id param so we use pattern matching to pull out the id from the parameter Map.      #
  # If you’ll remember from our list of routes, /posts/:id is the path that gets us to this function.                             #
  # The ":id" portion of that route specifies that whatever we put into that position will be passed as the id in the params Map. #
  #################################################################################################################################

  #######################################################################
  # Note. The fat arrow designates a key => value pair within a map.    #
  # where the name of the map is assigned to the variable placeholder   #
  # Create - recieve the parameters needed for one new registration     #
  #  and then saves the registration to the data store.                 #
  # Need only - (1) student_id, (2) class_id , (3) semester             #
  #######################################################################
  def create(conn, %{"registration" => registration_params}) do
    IO.puts("Create registration")
    # %{"class_id" => "39", "semester" => "1", "student_id" => "30"}
    IO.inspect(registration_params)

    case Auction.create_registration(registration_params) do
      {:ok, registration} ->
        conn
        # |> put_flash(:info, "Registration created successfully.")
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
    |> render("index.html")

    # render(conn, "index.html", %{students: students, lastname: lastname})
    # layout: {AuctionWeb.LayoutView, "indexstudent.html"})
  end

  # registration id
  def show(conn, %{"id" => id}) do
    IO.puts("SHOW ID")
    student_id = Auction.get_student_id_from_registration(id)

    regdata = Auction.get_class_from_registration(id)
    # |> IO.inspect()

    reg_list = Auction.get_registration_by_one(id)
    reg_map = Enum.at(reg_list, 0)

    registration_id = reg_map.id
    # |> IO.inspect()

    IO.puts("shos reg id")
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

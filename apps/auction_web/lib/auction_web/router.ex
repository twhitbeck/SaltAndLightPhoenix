defmodule AuctionWeb.Router do
  use AuctionWeb, :router
  import Phoenix.LiveView.Router

  ############################################################################
  # See https://www.youtube.com/watch?v=DHwUmDrWNys&ab_channel=AlchemistCamp #
  # (1) Find the matching route                                              #
  # (2) Dispatch the matching function                                       #
  # NOTE: The router pipelines the conn structure in to the controller       #
  ############################################################################

  @options [:show, :new, :create, :edit, :update, :delete, :index]
  @roptions [:show, :new, :create, :index]

  # pass conn thru from first defined to last defined
  pipeline :browser do
    plug(:accepts, ["html", "json"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {AuctionWeb.LayoutView, :root})
    # plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(AuctionWeb.Authenticator)
  end

  pipeline :api do
    plug(:accepts, ["json", "html"])
  end

  scope "/", AuctionWeb do
    live("/thermostat", ThermostatLive)
    get("/profiles", ProfileController, :show)
    pipe_through(:browser)
    #########################################
    # pass conn thru the :browser pipeline  #
    # Stored dispatch function for "/" is   #
    #  fn conn ->                           #
    #    plug = AuctionWeb.PageController   #
    #    opts = plug.init(:index)           #
    #    plug.call(conn, opts) _ init META  #
    #########################################
    # student_registration_path  GET     /students/:student_id/registrations/:id  AuctionWeb.RegistrationController :show

    # iex(22)> AuctionWeb.Router.Helpers.student_path(AuctionWeb.Endpoint, :edit,1)
    # iex(3)> AuctionWeb.Router.Helpers.user_student_path(AuctionWeb.Endpoint, :show,1,1)

    get("/", PageController, :index)
    # get("/redirect_test", PageController, :redirect_test)
    # get("/new_registration", RegistrationController, :new)
    resources("/users", UserController, only: [:show, :new, :create])
    resources("/profiles", ProfileController, singleton: true)
    # resources("/registrations", RegistrationController, only: [:delete])

    resources("/classes", ClassController, only: @roptions)
    # forward("/profile", Plugs.ProfileRedirector)

    # resources "/students", StudentController, only: [:index, :new, :create] do
    #  resources("/registrations", RegistrationController, only: [:delete])
    # end
    # end

    #  student_class_path and student_registration_path nested resources
    resources "/students", StudentController, only: @options do
      resources("/registrations", RegistrationController, only: @roptions)
      delete("/registrations", RegistrationController, :delete)
    end

    # student_class_path
    # resources "/students", StudentController, only: @options do
    #  resources "/classes", ClassController, only: @coptions
    # end

    # get       "/students", StudentController, :index
    # resources "/students", StudentController, only: @options
    delete("/logout", SessionController, :delete)
    get("/login", SessionController, :new)
    post("/login", SessionController, :create)

    # live_dashboard "/dashboard", metrics: AuctionWeb.Telemetry
  end

  # scope "/api", AuctionWeb do
  #   pipe_through(:api)
  #  delete("/registrations", RegistrationController, :delete)
  # end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through(:browser)

      # forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end

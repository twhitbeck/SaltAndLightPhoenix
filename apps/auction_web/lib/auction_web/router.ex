defmodule AuctionWeb.Router do
  use AuctionWeb, :router

  ##################################################################
  # (1) Find the matching route
  # (2) Dispatch the matching function
  @options  [:show, :new, :create, :edit, :update, :delete, :index]
  @roptions [:show, :new, :create, :delete, :index]

  pipeline :browser do # pass conn thru from first defined to last defined
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {AuctionWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug AuctionWeb.Authenticator
  end

  pipeline :api do
    plug :accepts, ["json"]
  end
  scope "/", AuctionWeb do
    pipe_through :browser
    #########################################
    # pass conn thru the :browser pipeline  #
    # Stored dispatch function for "/" is   #
    #  fn conn ->                           #
    #    plug = AuctionWeb.PageController   #
    #    opts = plug.init(:index)           #
    #    plug.call(conn, opts) _ init META  #
    #########################################
    #student_registration_path  GET     /students/:student_id/registrations/:id  AuctionWeb.RegistrationController :show

    #iex(22)> AuctionWeb.Router.Helpers.student_path(AuctionWeb.Endpoint, :edit,1)
    #iex(3)> AuctionWeb.Router.Helpers.user_student_path(AuctionWeb.Endpoint, :show,1,1)

      get       "/"        ,       PageController,           :index
      resources "/users"   ,       UserController,           only: [:show, :new, :create]
      resources "/profiles",       ProfileController,        singleton: true
      resources "/students",       StudentController,        only: @options do
      resources "/registrations",  RegistrationController,   only: @roptions
     #get       "/registratioms",  RegistrationController,
    end
     #get       "/students", StudentController, :index
    #resources "/students", StudentController, only: @options
      delete    "/logout"  , SessionController, :delete
      get       "/login"   , SessionController, :new
      post      "/login"   , SessionController, :create

    #live_dashboard "/dashboard", metrics: AuctionWeb.Telemetry
  end


  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

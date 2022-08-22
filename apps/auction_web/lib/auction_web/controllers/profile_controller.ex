defmodule AuctionWeb.ProfileController do
  use AuctionWeb, :controller

  alias Auction.Profile

  plug :require_logged_in_user

  # plug :prevent_unauthorized_access when action in [:show]

  # @profile_map = %{title: title, lastname: lastname, firstname: firstname, spousename: spousename, streetaddress: streetaddress, city: city,
  # state: state, zipcode: zipcode, phoneone: phoneone, phonetwo: phonetwo}

  # override app.html in layout
  # layout: {AuctionWeb.LayoutView, "showprofile.html"})

  def index(conn, _params) do
    IO.puts("Profile Index")
    profile = Auction.new_profile()
    render(conn, "index.html", profile: profile)
  end

  # def create(conn, %{"profile" => profile_params}) do
  #   params = Auction.Profile.changeset(profile_params)
  #  case Auction.insert_profile(params) do
  #    {:ok, profile} -> redirect(conn, to: Routes.profile_path(conn, :show, profile))
  #    {:error, profile} -> render(conn, "new.html", profile: profile)
  #  end
  # end

  ######################################
  # profile is a changeset             #
  # profile.data is a schema struct    #
  # in the new case all fields are nil #
  ######################################
  # conn - a plug containing request and response information.
  def new(conn, _params) do
    # an empty changeset
    profile = Auction.new_profile()
    current_user = Map.get(conn.assigns, :current_user)
    # , conn: conn)
    render(conn, "new.html", profile: profile, current_user: current_user)
  end

  # stuff = Student.changeset(%Student{}, studentparams)
  # %{"id" => id}) do
  def show(conn, _params) do
    current_user = Map.get(conn.assigns, :current_user)
    userid = current_user.id
    # return nil or return a profile changeset
    profile = Auction.check_profile(userid)
    action = 1

    case profile do
      nil ->
        render(conn, "new.html", profile: profile, current_user: current_user, action: action)

      _ ->
        render(conn, "show.html",
          profile: profile,
          layout: {AuctionWeb.LayoutView, "showprofile.html"}
        )
    end
  end

  def create(conn, %{"profile" => profile_params}) do
    # get current_user
    current_user = Map.get(conn.assigns, :current_user)
    # get current_user.id
    userid = current_user.id
    # insert user :id into student :user_id
    profileparams = Map.put(profile_params, "user_id", userid)
    # %Student{}#Auction.Student

    stuff = Profile.changeset(%Profile{}, profileparams)
    # stuff = assign(stuff, :action, Routes.student_path(conn, :show))

    # Auction.insert_student(studentparams) do
    case stuff do
      {:ok, profile} -> redirect(conn, to: Routes.profile_path(conn, :show, profile))
      {:error, profile} -> render(conn, "new.html", Profile: profile)
    end
  end

  # %{"id" => id}) do
  def edit(conn, _params) do
    current_user = Map.get(conn.assigns, :current_user)
    userid = current_user.id
    # changeset
    profile = Auction.show_profile(userid)
    render(conn, "edit.html", profile: profile, conn: conn)
  end

  def update(conn, profile_params) do
    current_user = Map.get(conn.assigns, :current_user)
    userid = current_user.id
    profile = Auction.get_profile(userid)
    # params = Auction.Profile.changeset(profile_params)
    case Auction.update_profile(profile, profile_params) do
      {:ok, profile} -> redirect(conn, to: Routes.profile_path(conn, :show, profile))
      {:error, profile} -> render(conn, "edit.html", profile: profile)
    end
  end

  # Pattern match to determine that there is no current user
  defp require_logged_in_user(%{assigns: %{current_user: nil}} = conn, _opts) do
    conn
    |> put_flash(:error, "You must be logged in to create a profile.")
    |> redirect(to: Routes.profile_path(conn, :index))
    |> halt()
  end

  # Pass on the conn because there is a current user
  defp require_logged_in_user(conn, _opts), do: conn
end

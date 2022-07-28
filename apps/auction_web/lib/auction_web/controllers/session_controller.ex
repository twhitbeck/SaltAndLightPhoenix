defmodule AuctionWeb.SessionController do
  use AuctionWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"username" => username, "password" => password}}) do
    case Auction.get_user_by_username_and_password(username, password) do
      %Auction.User{} = user ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Successfully logged in")
        |> redirect(to: Routes.user_path(conn, :show, user))
    _ ->
        conn
          |> put_flash(:error, "That username and password combination can not be found")
          |> render("new.html")
    end # case
  end #def

  def delete(conn, _params) do
    IO.puts("DELETE DELETE DELETE")
    conn
    |> clear_session()  # clear any cookies in the users browser of any data indicating that user is logged in.
    |> configure_session(drop: true)
    |> redirect(to: Routes.page_path(conn, :index))
    end

end

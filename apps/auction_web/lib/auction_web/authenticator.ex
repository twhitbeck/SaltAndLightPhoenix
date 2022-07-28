defmodule AuctionWeb.Authenticator do  # amodule plug
  import Plug.Conn

  def init(opts), do: opts # 1'st rewuirement

  def call(conn, _opts) do # 2'nd requirement
    user =
      conn
      |> get_session(:user_id)
      |> case do
        nil -> nil
        id -> Auction.get_user(id)
      end #case
      assign(conn, :current_user, user)  # store either id or nil in current_user in conn
  end # call

end

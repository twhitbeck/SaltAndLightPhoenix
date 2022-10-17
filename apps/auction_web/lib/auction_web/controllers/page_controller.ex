defmodule AuctionWeb.PageController do
  # calls import Phoenix Controller
  use AuctionWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

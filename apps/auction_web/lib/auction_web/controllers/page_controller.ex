defmodule AuctionWeb.PageController do
  use AuctionWeb, :controller # calls import Phoenix Controller

  # conn - a Plug.Conn struct request thru response (render)
  # 1 get a list of items
  # 2 bind the list to a variable
  # 3 pass that list to a template to render the items
  def index(conn, _params) do
    render(conn, "index.html")  # 3 render/3 Phoenix.Controller
  end
end

# second parameter of the Phoenix.Controller.render/3
# function on the last line of index/2 is "index.html" .
# defines the template to render the web page

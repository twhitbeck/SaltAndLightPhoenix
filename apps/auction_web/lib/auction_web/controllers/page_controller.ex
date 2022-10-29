defmodule AuctionWeb.PageController do
  # calls import Phoenix Controller
  use AuctionWeb, :controller

  ##########################################################################################################
  # The router pipelines the Conn data structure into the controller                                       #
  # The controller interacts with the model to fetch data from the database and render it using templates. #
  # Templates can be HTML or JSON files.                                                                   #
  # Here, the endpoint, router, and controllers are plugs                                                  #
  # EVERYTHING IN PHOENIX is a COMPOSABLE FUNCTION that TRANSFORMS DATA INTO DIFFERENT STRUCTURE.          #
  # ########################################################################################################

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

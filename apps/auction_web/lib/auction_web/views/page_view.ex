defmodule AuctionWeb.PageView do
  use AuctionWeb, :view

  ######################################################
  # template at templates/page/index.html.eex gets     #
  # converted into a function inside PageView as       #
  #    def render("index.html", assigns) do            #
  #        contents of index.html as string which gets #
  #        paired with EEX engine with the variables   #
  #        assigned in 'assigns'                       #
  #    end                                             #
  ######################################################
  def render("index.html", assigns) do
    "rendering with assigns #{inspect(Map.keys(assigns))}"
  end
end

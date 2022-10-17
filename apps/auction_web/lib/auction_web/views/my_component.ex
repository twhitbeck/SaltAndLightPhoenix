defmodule(AuctionWeb.MyComponent) do
  use Phoenix.Component

  def greeting(assigns) do
    ~H"""
      <h1> Hello <%= assigns.name %>  </h1>
    """
  end
end

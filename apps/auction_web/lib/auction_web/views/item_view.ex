defmodule AuctionWeb.ItemView do
  use AuctionWeb, :view

  # view passes the Plug.conn struct to the correct template
  # view passes any other assigns - such as @items

  #def integer_to_currency(cents) do
  #  dollars_and_cents =
  #    cents
  #    |> Decimal.div(100)
  #    |> Decimal.round(2)
  #    "$#{dollars_and_cents}"
  #  end

end

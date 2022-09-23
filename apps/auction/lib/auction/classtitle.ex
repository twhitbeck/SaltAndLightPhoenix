defmodule Auction.Classtitle do
  use Ecto.Schema
  import Ecto.Changeset
  #alias Auction.{Class, Classtitle}
  schema "classtitles" do
    field  :description,  :string
    has_many              :classes,  Auction.Class
    timestamps()
  end

  def changeset(classtitle, params \\ %{}) do
    classtitle
    |> Ecto.Changeset.cast(params, [:description])
  end

end

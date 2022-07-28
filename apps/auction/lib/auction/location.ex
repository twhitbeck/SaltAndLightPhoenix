defmodule Auction.Location do
  use Ecto.Schema
  import Ecto.Changeset

  schema "classes" do
    field :section,      :string
    field :hour,         :string
    field :fallfee,      :integer
    field :springfee,    :integer
    field :location_id,  :string
    field  :description, :string
    timestamps()
  end
end

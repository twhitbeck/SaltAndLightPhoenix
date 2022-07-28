defmodule Auction.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    add :location, :string
    timestamps()
  end
end

defmodule Auction.Repo.Migrations.CreateSections do
  use Ecto.Migration
  def change do
    create table("sections") do
      add :description, :string
      timestamps()
    end
  end
end

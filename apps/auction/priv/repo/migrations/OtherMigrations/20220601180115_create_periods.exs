defmodule Auction.Repo.Migrations.CreatePeriods do
  use Ecto.Migration
  def change do
    create table("periods") do
      add :time, :string
      timestamps()
    end
  end
end

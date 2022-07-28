defmodule Auction.Repo.Migrations.CreateClassTitles do
  use Ecto.Migration

  def change do
    create table("classtitles") do
      add :description, :string
      timestamps()
    end
  end

end

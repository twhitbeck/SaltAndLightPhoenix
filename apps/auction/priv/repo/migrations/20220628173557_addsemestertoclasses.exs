defmodule Auction.Repo.Migrations.Addsemestertoclasses do
  use Ecto.Migration

  def change do
    alter table(:registrations) do
      add :semester, :integer
    end
  end
end

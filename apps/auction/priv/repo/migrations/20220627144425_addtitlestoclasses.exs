defmodule Auction.Repo.Migrations.AddAssociationsToBids do
  use Ecto.Migration

  def change do
    alter table(:classes) do
      add :title_id, references(:classtitles)
    end
  end
end

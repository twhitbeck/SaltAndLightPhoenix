defmodule Auction.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :ptitle,         :string
      add :lastname,      :string
      add :firstname,     :string
      add :spousename,    :string
      add :streetaddress, :string
      add :city,          :string
      add :state,         :string
      add :zipcode,       :string
      add :phoneone,      :string
      add :phonetwo,      :string
      add :currentmember, :string
      add :user_id, references(:users)
      timestamps()
    end
    create unique_index(:profiles, [:user_id])
  end
end

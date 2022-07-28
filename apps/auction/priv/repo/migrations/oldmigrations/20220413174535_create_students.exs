defmodule Auction.Repo.Migrations.CreateStudents do
  use Ecto.Migration

  def change do
    create table("students") do
      add :firstname, :string
      add :grade,     :string
      add :birthday,  :string
      add :user_id,   references(:users)
      timestamps()
    end
    create index(:students, [:user_id])
  end

end

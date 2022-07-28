defmodule Auction.Repo.Migrations.CreateClasses do
  use Ecto.Migration

  def change do
    create table(:classes) do
      add :hour,        :string
      add :description, :string
      add :section,     :string
      add :location,    :string
      add :fallfee,     :string
      add :springfee,   :string
      add :location,    :string
      add :period,      references(:periods)
      add :section,     references(:sections)
      add :classtitle,  references(:classtitles)
      add :teacher_id,  references(:users)
      add :helper1_id,  references(:users)
      add :helper2_id,  references(:users)

      timestamps()
    end
   end

end

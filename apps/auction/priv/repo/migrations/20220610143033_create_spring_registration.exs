defmodule Auction.Repo.Migrations.CreateSpringRegistration do
  use Ecto.Migration


  def change do
    create table(:spring_registrations) do
      add :student_id,  references(:students)
      add :class_id,    references(:classes)
      timestamps()
    end
   end
end

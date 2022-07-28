defmodule Auction.Registration do
  use Ecto.Schema
  import Ecto.Changeset
  alias Auction.{Class, Student}

  schema "registrations" do
    #field :student_id,  :integer
    #field :class_id,    :integer
    field :semester,     :integer
    belongs_to :class,   Auction.Class         #reference registration.class    - class_id is a foreign key
    belongs_to :student, Auction.Student       #reference registration.students - student_id is a foreign key

    timestamps()
  end

  @fields  [:student_id, :class_id]

  def changeset(registration, params \\ %{}) do # if no data - return a blank changeset
  IO.puts("REGISTRATION SCHEMA")
  IO.inspect(registration)
    registration
      |> cast(params,  @fields)  # cast returns a changeset
      |> validate_required(@fields)
      #|> assoc_constraint(:student)  # Look for associated records in database - if they don't exist kill the query
       IO.puts("done changeset")
    end

end

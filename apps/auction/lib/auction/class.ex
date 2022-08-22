defmodule Auction.Class do
  use Ecto.Schema
  import Ecto.Changeset
  alias Auction.{Registration, Classtitle}

  schema "classes" do
    field(:location, :string)
    field(:fallfee, :integer)
    field(:springfee, :integer)
    field(:semester, :integer)
    belongs_to(:period, Auction.Period)
    belongs_to(:section, Auction.Section)
    belongs_to(:teacher, Auction.User)
    belongs_to(:helper1, Auction.User)
    belongs_to(:helper2, Auction.User)
    belongs_to(:classtitle, Auction.Classtitle)
    has_many(:registrations, Auction.Registration)
    # belongs_to :student,  Auction.Student
    timestamps()
  end

  @fields [:fallfee, :springfee]

  # if no data - return a blank changeset
  def changeset(class, params \\ %{}) do
    IO.puts("CLASS SCHEMA")
    IO.inspect(class)

    class
    # cast returns a changeset
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> cast_assoc(:classtitle, required: true)

    # |> assoc_constraint(:student)  # Look for associated records in database - if they don't exist kill the query
    IO.puts("done changeset")
  end
end

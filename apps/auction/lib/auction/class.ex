defmodule Auction.Class do
  use Ecto.Schema
  import Ecto.Changeset
  alias Auction.{Registration, Classtitle}

  schema "classes" do
    field :location,     :string
    field :fallfee,      :integer
    field :springfee,    :integer
    belongs_to           :period,         Auction.Period
    belongs_to           :section,        Auction.Section
    belongs_to           :teacher,        Auction.User
    belongs_to           :helper1,        Auction.User
    belongs_to           :helper2,        Auction.User
    belongs_to           :classtitle,     Auction.Classtitle
    has_many             :registrations,  Auction.Registration
    #belongs_to :student,  Auction.Student
    timestamps()
  end

  @fields  [:section, :hour, :fallfee, :springfee]

  def changeset(class, params \\ %{}) do # if no data - return a blank changeset
  IO.puts("CLASS SCHEMA")
  IO.inspect(class)
    class
      |> cast(params,  @fields)  # cast returns a changeset
      |> validate_required(@fields)
      |> cast_assoc(:classtitles, required: true)
      #|> assoc_constraint(:student)  # Look for associated records in database - if they don't exist kill the query
       IO.puts("done changeset")
    end

end

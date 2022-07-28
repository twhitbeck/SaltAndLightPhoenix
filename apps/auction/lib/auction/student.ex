defmodule Auction.Student do
  use Ecto.Schema
  import Ecto.Changeset

  schema "students" do
    field      :firstname,     :string
    field      :grade,         :string
    field      :birthday,      :string
    has_many   :registrations, Auction.Registration
    belongs_to :user,          Auction.User         #reference student.user - user_id is a foreign key
    timestamps()
  end

  @fields  [:firstname, :grade, :user_id]

  #############################################################################################
  # student is a struct as laid out in the "students" schema                                  #
  # Most Ecto.changeset functions accept either a struct or a changeset struct                #
  # The given data may be either a CHANGESET, a SCHEMA STRUCT or a {data, types} TUPLE        #
  # The second argument is a map of params according to type info from data                   #
  # params is a MAP with STRING KEYS or ATOM KEYS.                                            #
  # Casting - all permitted parameters whose values match the type info will have             #
  # their Key name converted to an atom and stored along with the value in the :changes field #
  #############################################################################################

  def changeset(student, params \\ %{}) do # if no data - return a blank changeset
    student
      |> cast(params,  @fields)  # cast returns a changeset
      |> validate_required(@fields)
      |> assoc_constraint(:user)  # Look for associated records in database - if they don't exist kill the query
       #IO.puts("done changeset")
    end


end

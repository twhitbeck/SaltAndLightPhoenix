defmodule Auction.Profile do
  use Ecto.Schema
  import Ecto.Changeset
  # %Auction.Profile{} is an empty schema struct

  schema "profiles" do
    field  :title,         :string
    field  :lastname,      :string
    field  :firstname,     :string
    field  :spousename,    :string
    field  :streetaddress, :string
    field  :city,          :string
    field  :state,         :string
    field  :zipcode,       :string
    field  :phoneone,      :string
    field  :phonetwo,      :string

    belongs_to :user,      Auction.User
    timestamps()
  end

  @fields  [:title, :lastname, :firstname, :spousename, :streetaddress, :city, :state, :zipcode, :phoneone, :phonetwo, :user_id]

  ###############################################################################
  # profile is a struct as laid out in the "profiles" schema                    #
  # Most Ecto.changeset functions accept either a struct or a changeset struct  #
  ###############################################################################

  def changeset(profile, data \\ %{}) do # data is a key, value pair
    profile
    |> cast(data, @fields)  # cast returns a changeset, @fields is a list
    |> validate_required([:lastname, :firstname, :user_id])
    |> assoc_constraint(:user)  # Look for associated records in database - if they don't exist kill the query
    |> unique_constraint(:my_constraint, name: :my_index) # tell ecto that there's a unique constraint
    |> IO.inspect
  end
end

#changeset = User.changeset(%User{}, %{age: 0, email: "mary@example.com"})

#defmodule User do
#  use Ecto.Schema
#  import Ecto.Changeset

#  schema "users" do
#    field :name
#    field :email
#    field :age, :integer
#  end

#  def changeset(user,data \\ %{}) do
#    user
#    |> cast(data, [:name, :email, :age])
#    |> validate_required([:name, :email])
#    |> validate_format(:email, ~r/@/)
#    |> validate_inclusion(:age, 18..100)
#    |> unique_constraint(:email)
#  end
#end

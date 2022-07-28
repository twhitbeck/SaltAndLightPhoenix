defmodule Auction.Section do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sections" do
    field :description, :string
    timestamps()
  end

  @fields  [:descrition]

  def changeset(section, params \\ %{}) do # if no data - return a blank changeset
  IO.puts("SECTION SECTION")
  IO.inspect(section)
    section
      |> cast(params,  @fields)  # cast returns a changeset
      |> validate_required(@fields)
       IO.puts("done changeset")
    end

end

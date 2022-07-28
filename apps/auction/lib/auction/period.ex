defmodule Auction.Period do
  use Ecto.Schema
  import Ecto.Changeset

  schema "periods" do
    field :time, :string
    timestamps()
  end

  @fields  [:time]

  def changeset(period, params \\ %{}) do # if no data - return a blank changeset
  IO.puts("PERIOD SCHEMA")
  IO.inspect(period)
    period
      |> cast(params,  @fields)  # cast returns a changeset
      |> validate_required(@fields)
      #|> assoc_constraint(:student)  # Look for associated records in database - if they don't exist kill the query
       IO.puts("done changeset")
    end

end

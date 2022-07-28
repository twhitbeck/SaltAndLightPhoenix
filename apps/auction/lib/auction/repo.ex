defmodule Auction.Repo do # Auction.Repo matches config.exs file
  use Ecto.Repo,
    otp_app: :auction,  # name of application
    adapter: Ecto.Adapters.Postgres # adapter to use
end

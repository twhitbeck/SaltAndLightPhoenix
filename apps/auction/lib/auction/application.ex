defmodule Auction.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true

  # Starts a worker by calling: Auction.Worker.start_link(arg)
  # {Auction.Worker, arg}

  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, name: AuctionWeb.PubSub},
      {Auction.Repo, []},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Auction.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

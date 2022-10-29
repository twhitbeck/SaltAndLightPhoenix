# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config



# :auction - Name of application
# ecto_repos: [Auction.Repo]_ a key value pair to configure
config :auction, ecto_repos: [Auction.Repo]  #config/2

# :auction - Name of application
# Auction.Repo - key to store the configuration under
# key value pairs for configuration
config :auction, Auction.Repo, # config/3
  database: "auction",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"

config :auction_web,
  generators: [context_app: false]

# Configures the endpoint
config :auction_web, AuctionWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: AuctionWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: AuctionWeb.PubSub,
  live_view: [signing_salt: "XN7duC6X"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/auction_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]


  config :phoenix, :template_engines, exs: Temple.Engine

  #config :tailwind, version: "3.1.8", default: [
  #  args: ~w(
  #    --config=tailwind.config.js
  #    --input=css/app.css
  #    --output=../priv/static/assets/app.css
  #  ),
  #  cd: Path.expand("../assets", __DIR__)
  #]

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
#
# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

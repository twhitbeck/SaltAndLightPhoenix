
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

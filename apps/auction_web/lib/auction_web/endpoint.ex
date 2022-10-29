defmodule AuctionWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :auction_web

  # SEE: https://blog.logrocket.com/build-rest-api-elixir-phoenix/

  # **************************************************************
  # If you want something to happen on ALL requests, do it here  *
  #                                                              *
  # NOTE: Phoenix recieves a request at the endpoint             *
  # AND endpoint converts the request into a conn structure      *
  # endpoint then forwards the conn to the router                *
  # **************************************************************

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_auction_web_key",
    signing_salt: "9gO9N9qQ"
  ]
  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :auction_web,
    gzip: false,
    only: ~w(assets fonts images favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  # last plug delegate all further processing
  plug AuctionWeb.Router
  #  to router
end

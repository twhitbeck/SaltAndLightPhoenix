defmodule AuctionWeb.ThermostatLive do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use Phoenix.LiveView

  def render(assigns) do
    IO.puts("TEMPERATURE")

    ~H"""
    #Current temperature: <%= IO.puts("HELLO") %>
    """
  end

  # def mount(_params, %{"current_user_id" => user_id}, socket) do
  #  temperature = Thermostat.get_user_reading(user_id)
  #  {:ok, assign(socket, :temperature, temperature)}
  # end
end

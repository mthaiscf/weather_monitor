defmodule WeatherMonitor.Repo do
  use Ecto.Repo,
    otp_app: :weather_monitor,
    adapter: Ecto.Adapters.Postgres
end

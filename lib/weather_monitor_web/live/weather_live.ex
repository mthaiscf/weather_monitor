defmodule WeatherMonitorWeb.WeatherMonitorWeb.WeatherLive do
  use Phoenix.LiveView
  alias WeatherMonitor.WeatherAPI

  @city "São Paulo"

  def mount(_params, _session, socket) do
    if connected?(socket), do: schedule_refresh()
    {:ok, fetch_weather(socket)}
  end

  def handle_info(:refresh, socket) do
    schedule_refresh()
    {:noreply, fetch_weather(socket)}
  end

  defp schedule_refresh() do
    Process.send_after(self(), :refresh, 60_000)
  end

  defp fetch_weather(socket) do
    case WeatherAPI.get_weather(@city) do
      {:ok, weather_data} ->
        assign(socket, weather: weather_data)

      {:error, _reason} ->
        assign(socket, weather: nil)
    end
  end

  def render(assigns) do
    ~H"""
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        .header {
            background-color: #4CAF50;
            color: white;
            padding: 15px;
            text-align: center;
        }
        .container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            padding: 20px;
        }
        .card {
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin: 10px;
            padding: 20px;
            width: 300px;
            text-align: center;
        }
        .card h2 {
            margin: 0;
            font-size: 24px;
        }
        .card p {
            font-size: 18px;
            color: #555;
        }
    </style>
    <h1>Weather in São Paulo</h1>

    <div class="header">
        <h1>Dashboard do Tempo</h1>
    </div>
    <div class="container">
        <div class="card">
            <h2>Temperatura</h2>
            <p>25°C</p>
        </div>
        <div class="card">
            <h2>Umidade</h2>
            <p>60%</p>
        </div>
        <div class="card">
            <h2>Vento</h2>
            <p>15 km/h</p>
        </div>
    </div>
    """
  end

end

defmodule WeatherMonitor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WeatherMonitorWeb.Telemetry,
      WeatherMonitor.Repo,
      {DNSCluster, query: Application.get_env(:weather_monitor, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: WeatherMonitor.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: WeatherMonitor.Finch},
      # Start a worker by calling: WeatherMonitor.Worker.start_link(arg)
      # {WeatherMonitor.Worker, arg},
      # Start to serve requests, typically the last entry
      WeatherMonitorWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WeatherMonitor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WeatherMonitorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

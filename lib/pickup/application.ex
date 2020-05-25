defmodule Pickup.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Pickup.Repo,
      # Start the Telemetry supervisor
      PickupWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Pickup.PubSub},
      # Start the Endpoint (http/https)
      PickupWeb.Endpoint,
      Pickup.BotConsumer
      # Start a worker by calling: Pickup.Worker.start_link(arg)
      # {Pickup.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pickup.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PickupWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

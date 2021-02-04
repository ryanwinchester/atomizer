defmodule Atomizer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      AtomizerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Atomizer.PubSub},
      # Start the Endpoint (http/https)
      AtomizerWeb.Endpoint
      # Start a worker by calling: Atomizer.Worker.start_link(arg)
      # {Atomizer.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Atomizer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    AtomizerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule SlackDoorman.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SlackDoormanWeb.Telemetry,
      # Start the Ecto repository
      SlackDoorman.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: SlackDoorman.PubSub},
      # Start Finch
      {Finch, name: SlackDoorman.Finch},
      # Start the Endpoint (http/https)
      SlackDoormanWeb.Endpoint,
      # Start a worker by calling: SlackDoorman.Worker.start_link(arg)
      # {SlackDoorman.Worker, arg}
      SlackDoorman.Worker
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SlackDoorman.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SlackDoormanWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

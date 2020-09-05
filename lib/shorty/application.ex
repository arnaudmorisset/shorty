defmodule Shorty.Application do
  use Application

  require Logger

  def start(_type, _args) do
    children = [
      Shorty.Repo,
      {Plug.Cowboy,
       scheme: :http,
       plug: Shorty.Router,
       options: [port: Application.get_env(:shorty, :cowboy_port, 8080)]}
    ]

    opts = [strategy: :one_for_one, name: Shorty.Supervisor]

    Logger.info("Starting application...")

    Supervisor.start_link(children, opts)
  end
end

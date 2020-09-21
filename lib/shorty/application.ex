defmodule Shorty.Application do
  use Application

  require Logger

  def start(_type, _args) do
    children = [
      Shorty.Repo,
      {Plug.Cowboy, scheme: :http, plug: Shorty.Router, options: [port: 4000]}
    ]

    opts = [strategy: :one_for_one, name: Shorty.Supervisor]

    Logger.info("Starting application...")

    Supervisor.start_link(children, opts)
  end
end

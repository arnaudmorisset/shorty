defmodule Shorty.Application do
  use Application

  def start(_type, _args) do
    children = [Shorty.Repo]
    opts = [strategy: :one_for_one, name: Shorty.Supervisor]

    Supervisor.start_link(children, opts)
  end
end

import Config

config :shorty, ecto_repos: [Shorty.Repo]

config :shorty, cowboy_port: 4000
config :shorty, domain_name: System.get_env("DOMAIN_NAME") || "localhost"
config :shorty, scheme: "http"

import_config "#{Mix.env()}.exs"

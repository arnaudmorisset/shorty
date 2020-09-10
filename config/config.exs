import Config

config :shorty, ecto_repos: [Shorty.Repo]

config :shorty, cowboy_port: 8080
config :shorty, domain_name: "localhost"
config :shorty, scheme: "http"

import_config "#{Mix.env()}.exs"

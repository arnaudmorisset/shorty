import Config

config :shorty, Shorty.Repo,
  database: "shorty_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :shorty, ecto_repos: [Shorty.Repo]

config :shorty, cowboy_port: 8080

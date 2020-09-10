use Mix.Config

config :shorty, Shorty.Repo,
  database: "shorty_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :warn

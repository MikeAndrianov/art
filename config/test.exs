use Mix.Config

config :art, Art.Repo,
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASSWORD"),
  database: "art_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

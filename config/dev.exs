use Mix.Config

config :art, Art.Repo,
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASSWORD"),
  pool_size: 10,
  database: "art_dev",
  hostname: "localhost"

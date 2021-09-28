import Config

config :art, ecto_repos: [Art.Repo]

import_config "#{config_env()}.exs"

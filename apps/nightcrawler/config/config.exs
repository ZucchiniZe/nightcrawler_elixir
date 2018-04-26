use Mix.Config

config :nightcrawler, ecto_repos: [Nightcrawler.Repo]

config :ecto, json_library: Jason
config :nightcrawler, Nightcrawler.Repo, types: Nightcrawler.PostgresTypes

import_config "#{Mix.env}.exs"

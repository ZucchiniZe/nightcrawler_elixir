use Mix.Config

config :nightcrawler, ecto_repos: [Nightcrawler.Repo]

import_config "#{Mix.env}.exs"

# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :nightcrawler,
  ecto_repos: [Nightcrawler.Repo]

# Configures the endpoint
config :nightcrawler, NightcrawlerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "GmssbvFLVg+icRrkAxJwCd51HFxy05+/ptwcfoo+B+5KY+OuPsKj/+ACkCS3HqAW",
  render_errors: [view: NightcrawlerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Nightcrawler.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# import_config "scout_apm.exs"

config :nightcrawler, Nightcrawler.Repo,
  loggers: [{Ecto.LogEntry, :log, []},
            {ScoutApm.Instruments.EctoLogger, :log, []}]

config :phoenix, :template_engines,
  eex: ScoutApm.Instruments.EExEngine,
  exs: ScoutApm.Instruments.ExsEngine
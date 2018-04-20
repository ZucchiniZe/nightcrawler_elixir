# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :nightcrawler_web,
  namespace: NightcrawlerWeb,
  ecto_repos: [Nightcrawler.Repo]

# Configures the endpoint
config :nightcrawler_web, NightcrawlerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "xUYcL1Gn1CTqSS9af+ctRVcAm4jLFcuNdk2PZ8nQdECvINUNTGXtMyfpppM7FPnC",
  render_errors: [view: NightcrawlerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: NightcrawlerWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :nightcrawler_web, :generators,
  context_app: :nightcrawler

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

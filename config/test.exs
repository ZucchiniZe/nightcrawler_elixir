use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :nightcrawler, NightcrawlerWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :nightcrawler, Nightcrawler.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATA_DB_USER"),
  password: System.get_env("DATA_DB_PASS"),
  hostname: System.get_env("DATA_DB_HOST"),
  database: "nightcrawler_test",
  pool: 10

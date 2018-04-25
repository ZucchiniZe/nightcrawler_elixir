use Mix.Config

# Configure your database
# make tests work on semaphore
config :nightcrawler, Nightcrawler.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATABASE_POSTGRESQL_USERNAME") || "postgres",
  password: System.get_env("DATABASE_POSTGRESQL_PASSWORD") || "postgres",
  database: "nightcrawler_dev",
  pool_size: 2

config :nightcrawler, Nightcrawler.Repo,
  loggers: [{Ecto.LogEntry, :log, []},
            {ScoutApm.Instruments.EctoLogger, :log, []}]

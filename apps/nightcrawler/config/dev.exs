use Mix.Config

# Configure your database
# make tests work on semaphore
unless System.get_env("CI") == "true" do
  config :nightcrawler, Nightcrawler.Repo,
    adapter: Ecto.Adapters.Postgres,
    username: "postgres",
    password: "postgres",
    database: "nightcrawler_dev",
    hostname: "localhost",
    pool_size: 10
else
  config :nightcrawler, Nightcrawler.Repo,
    adapter: Ecto.Adapters.Postgres,
    username: System.get_env("DATABASE_POSTGRESQL_USERNAME"),
    password: System.get_env("DATABASE_POSTGRESQL_PASSWORD"),
    database: "nightcrawler_dev",
    hostname: "localhost",
    pool_size: 10
end

config :nightcrawler, Nightcrawler.Repo,
  loggers: [{Ecto.LogEntry, :log, []},
            {ScoutApm.Instruments.EctoLogger, :log, []}]

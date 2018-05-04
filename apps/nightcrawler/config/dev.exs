use Mix.Config

# Configure your database
config :nightcrawler, Nightcrawler.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "nightcrawler_dev",
  pool_size: 2

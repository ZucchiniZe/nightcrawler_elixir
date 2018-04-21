use Mix.Config

# Configure your database
config :nightcrawler, Nightcrawler.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "nightcrawler_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenix_social, PhoenixSocial.Endpoint,
  http: [port: 4001],
  server: true,
  cache_static_lookup: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :phoenix_social, PhoenixSocial.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "phoenix_social_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :hound, browser: "chrome"

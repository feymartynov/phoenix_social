# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phoenix_social,
  ecto_repos: [PhoenixSocial.Repo]

# Configures the endpoint
config :phoenix_social, PhoenixSocial.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4Xu30rOgNpMBLoorJJvwycra8epuFFehjuOM6U71L2tvPD8M9t+5s1DL31NQOUWK",
  render_errors: [view: PhoenixSocial.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PhoenixSocial.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

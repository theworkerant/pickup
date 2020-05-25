# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

discord_token =
  System.get_env("DISCORD_TOKEN") || raise "environment variable DISCORD_TOKEN is missing."

config :pickup,
  ecto_repos: [Pickup.Repo]

# Configures the endpoint
config :pickup, PickupWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "f/h+CfAiJES65leYas9mOaxHVR/5/GLv37v6bdVQ+RKxEidZkdCsI+Y7Wh7jbwcR",
  render_errors: [view: PickupWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Pickup.PubSub,
  live_view: [signing_salt: "zTMnCi2i"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :nostrum,
  token: discord_token,
  num_shards: :auto

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

discord_app_id =
  System.get_env("DISCORD_APP_ID") || raise "environment variable DISCORD_APP_ID is missing."

discord_app_secret =
  System.get_env("DISCORD_APP_SECRET") ||
    raise "environment variable DISCORD_APP_SECRET is missing."

discord_bot_token =
  System.get_env("DISCORD_BOT_TOKEN") ||
    raise "environment variable DISCORD_BOT_TOKEN is missing."

config :pickup,
  ecto_repos: [Pickup.Repo]

# Configures the endpoint
config :pickup, PickupWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "f/h+CfAiJES65leYas9mOaxHVR/5/GLv37v6bdVQ+RKxEidZkdCsI+Y7Wh7jbwcR",
  render_errors: [view: PickupWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Pickup.PubSub,
  live_view: [signing_salt: "zTMnCi2i"],
  protocol_options: [max_request_line_length: 8192, max_header_value_length: 8192]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :nostrum,
  token: discord_bot_token,
  num_shards: :auto

config :ueberauth, Ueberauth,
  providers: [
    discord:
      {Ueberauth.Strategy.Discord,
       [
         default_scope: "identify email connections guilds"
       ]}
  ]

config :ueberauth, Ueberauth.Strategy.Discord.OAuth,
  client_id: discord_app_id,
  client_secret: discord_app_secret

config :pickup, Pickup.Guardian,
  issuer: "pickup",
  secret_key: "qn9G5TZxuXM5cK4lgnql8OXkkENjXvox2EQ7PHHchpbTZOTH49PWVKQuSzIt6G+X"

config :pickup, Pickup.Vault,
  ciphers: [
    default: {
      Cloak.Ciphers.AES.GCM,
      # In AES.GCM, it is important to specify 12-byte IV length for
      # interoperability with other encryption software. See this GitHub
      # issue for more details:
      # https://github.com/danielberkompas/cloak/issues/93
      #
      # In Cloak 2.0, this will be the default iv length for AES.GCM.
      tag: "AES.GCM.V1",
      key: Base.decode64!("mp/CJ/V98IkcArrP6fSdibDnf+GLfIerTBduFdssquA="),
      iv_length: 12
    }
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :time_manager,
  ecto_repos: [TimeManager.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :time_manager, TimeManagerWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: TimeManagerWeb.ErrorHTML, json: TimeManagerWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: TimeManager.PubSub,
  live_view: [signing_salt: System.get_env("SIGNING_SALT") || "placeholder_salt_replace_in_production"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :time_manager, TimeManager.Mailer, adapter: Swoosh.Adapters.Local

config :joken, default_signer: System.get_env("SECRET_KEY_BASE") || "placeholder_key_replace_in_production"

# config :time_manager, jwt_secret: "super_secret_key"

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  time_manager: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  time_manager: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :cors_plug,
  origin: ["http://localhost:8080", "http://localhost:8081"],
  max_age: 86400,
  methods: ["GET", "POST", "PUT", "PATCH", "DELETE"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

import Config

config :time_manager, TimeManager.Repo,
  username: System.get_env("POSTGRES_USER"),
  password: System.get_env("POSTGRES_PASSWORD"),
  hostname: System.get_env("PGHOST"),
  database: System.get_env("POSTGRES_DB"),
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :time_manager, TimeManagerWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000],
  check_origin: false,
  code_reloader: false,
  debug_errors: true,
  secret_key_base: System.get_env("SECRET_KEY_BASE") || "placeholder_key_replace_in_production",
  watchers: []

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

config :time_manager, TimeManager.Mailer, adapter: Swoosh.Adapters.Local

# Configurez le client API pour ne pas utiliser Hackney
config :swoosh, :api_client, false

# Ajoutez ces lignes à la fin du fichier
config :phoenix_live_view,
  debug_heex_annotations: false,
  enable_expensive_runtime_checks: false

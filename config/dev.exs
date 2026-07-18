import Config

current_ip =
  case :os.type() do
    {:unix, :darwin} ->
      System.cmd("ipconfig", ["getifaddr", "en0"]) |> elem(0) |> String.trim()

    _ ->
      "127.0.0.1"
  end

# core_auth Repo (config of path deps is not loaded automatically)
config :core_auth, CoreAuth.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "auth",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# Do not start core_auth's HTTP endpoint inside core_api
config :core_auth, CoreAuthWeb.Endpoint,
  server: false,
  secret_key_base: "oNVDyJ2tiJHZ8DkgpVez1ybPGnMpEicO46gNhZX2xXhfJjAbVL+FRM1AZGm+zFiJ"

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we can use it
# to bundle .js and .css sources.
config :core_api, CoreApiWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: String.to_integer(System.get_env("PORT") || "4000")],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "Q2Ranj1Jt94vY9JuYUsc8yhOaSzA0WGt80QiAoUSuELKnK6QeCiahMVLEcadz6GD",
  watchers: []

# Enable dev routes for dashboard and mailbox
config :core_api, dev_routes: true

# Do not include metadata nor timestamps in development logs
config :logger, :default_formatter, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

config :libcluster,
  topologies: [
    api: [
      strategy: Cluster.Strategy.Epmd,
      config: [
        hosts: [
          :"core_api@#{current_ip}",
          :"invest@#{current_ip}"
        ]
      ]
    ]
  ]

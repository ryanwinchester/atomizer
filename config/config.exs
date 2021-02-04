# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :atomizer, AtomizerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "EIRyyDTuSUd33B0Frx/1wjGAIttaKNyA3psLetbn6Z7+HN5rM3kJrw9uwJp9S46f",
  render_errors: [view: AtomizerWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Atomizer.PubSub,
  live_view: [signing_salt: "o0ARxreK"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

import Config

if config_env() == :prod do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  app_name =
    System.get_env("FLY_APP_NAME") ||
      raise "FLY_APP_NAME not available"

  config :atomizer, AtomizerWeb.Endpoint,
    server: true,
    url: [host: "#{app_name}.fly.dev", port: 80],
    http: [
      port: String.to_integer(System.get_env("PORT") || "4000"),
      # IMPORTANT: support IPv6 addresses
      transport_options: [socket_opts: [:inet6]]
    ],
    secret_key_base: secret_key_base
end

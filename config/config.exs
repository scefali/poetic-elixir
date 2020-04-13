# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :poetic,
  ecto_repos: [Poetic.Repo]

# Configures the endpoint
config :poetic, PoeticWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LC9xrmrz5LZi3XV6ymF/4w2Pcg5BDe9PW7QrBN+D5LDsnapI5d6V595rfZbBuhUb",
  render_errors: [view: PoeticWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Poetic.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "DaPwCadF"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

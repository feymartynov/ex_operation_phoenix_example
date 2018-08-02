# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ex_operation_phoenix_example,
  namespace: App,
  ecto_repos: [App.Repo]

# Configures the endpoint
config :ex_operation_phoenix_example, AppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nHSk96OgcAJRztkRGb+CbvkGbYaEotVFIv0Q8/uIyKkl2xfVuRcHP7+q7TubPWYA",
  render_errors: [view: AppWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: App.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :ex_operation,
  repo: App.Repo

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

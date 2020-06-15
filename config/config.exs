# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :project_algo_lv,
  ecto_repos: [ProjectAlgoLv.Repo]

# Configures the endpoint
config :project_algo_lv, ProjectAlgoLvWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "uFagIrnfWTLgEBxSmiZVK8Osld7mGzFLlWiquhcU57tRWXJTtVRK8qqScB4Ul13o",
  render_errors: [view: ProjectAlgoLvWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ProjectAlgoLv.PubSub,
  live_view: [signing_salt: "h+7ad2Dc"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# DynamoDb
config :ex_aws,
  debug_requests: false, # set to true to monitor the DDB requests
  access_key_id: System.get_env("AWS_ACCESS_KEY"),
  secret_access_key: System.get_env("AWS_SECRET_KEY"),
  region: System.get_env("DYNAMODB_REGION")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

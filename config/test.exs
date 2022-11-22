import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :kon, Kon.Repo,
       adapter: Ecto.Adapters.SQLite3,
       database: "./db/test.sqlite"

config :my_app, MyApp.Repo,
       adapter: Ecto.Adapters.SQLite3,
       database: "/path/to/sqlite/database"

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :kon, KonWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "UEX8JipxhNRTkMMHqozSzl/xpsUe46DwF8Gvxx5cZxaVh//ZPacp6DivlKQUopyG",
  server: false

# In test we don't send emails.
config :kon, Kon.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

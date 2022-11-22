defmodule Kon.Repo do
  use Ecto.Repo, otp_app: :kon, adapter: Ecto.Adapters.SQLite3
end

defmodule Art.Repo do
  use Ecto.Repo,
    otp_app: :art,
    adapter: Ecto.Adapters.Postgres
end

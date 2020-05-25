defmodule Pickup.Repo do
  use Ecto.Repo,
    otp_app: :pickup,
    adapter: Ecto.Adapters.Postgres
end

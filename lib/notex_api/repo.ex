defmodule Notex.Repo do
  use Ecto.Repo,
    otp_app: :notex_api,
    adapter: Ecto.Adapters.Postgres
end

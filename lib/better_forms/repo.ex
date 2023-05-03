defmodule BetterForms.Repo do
  use Ecto.Repo,
    otp_app: :better_forms,
    adapter: Ecto.Adapters.Postgres
end

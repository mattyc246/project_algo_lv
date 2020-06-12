defmodule ProjectAlgoLv.Repo do
  use Ecto.Repo,
    otp_app: :project_algo_lv,
    adapter: Ecto.Adapters.Postgres
end

defmodule ProjectAlgoLvWeb.StripeClientToken do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> assign(:stripe_publishable_key, System.get_env("STRIPE_PUBLISHABLE_KEY"))
  end
end
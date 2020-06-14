defmodule ProjectAlgoLvWeb.LoginRequired do
  import Plug.Conn

  use ProjectAlgoLvWeb, :controller

  def init(opts), do: opts

  def call(conn = %{assigns: %{current_user: current_user}}, _opts) when current_user != nil do
    conn
  end

  def call(conn, _opts) do
    conn
    |> put_flash(:error, "Login required")
    |> redirect(to: Routes.session_path(conn, :new))
    |> halt()
  end
end
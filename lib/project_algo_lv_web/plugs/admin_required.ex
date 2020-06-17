defmodule ProjectAlgoLvWeb.AdminRequired do
  import Plug.Conn

  use ProjectAlgoLvWeb, :controller

  def init(opts), do: opts

  def call(conn, _opts) do
    if Enum.member?(conn.assigns.current_user.roles, "admin") do
      conn
    else
      conn
      |> put_flash(:error, "Unauthorized")
      |> redirect(to: Routes.dashboard_index_path(conn, :index))
      |> halt()
    end
  end
end
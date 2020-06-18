defmodule ProjectAlgoLvWeb.MembershipRequired do
  import Plug.Conn

  use ProjectAlgoLvWeb, :controller

  def init(opts), do: opts

  def call(conn, _opts) do
    active_memberships = Enum.reduce(conn.assigns.current_user.memberships, [], fn m, acc ->
      if DateTime.compare(m.end_date, DateTime.utc_now) == :gt do
        [m | acc]
      else
        acc
      end
    end)
    if Enum.count(active_memberships) > 0 || (Enum.member?(conn.assigns.current_user.roles, "admin") || Enum.member?(conn.assigns.current_user.roles, "moderator")) do
      conn
    else
      conn
      |> put_flash(:error, "No active memberships")
      |> redirect(to: Routes.membership_path(conn, :new))
      |> halt()
    end
  end
end
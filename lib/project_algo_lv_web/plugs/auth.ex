defmodule ProjectAlgoLvWeb.Auth do
  import Plug.Conn

  alias ProjectAlgoLv.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = user_id && Accounts.get_user_with_membership(user_id)

    conn
    |> assign(:current_user, user)
    |> put_user_token
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  defp put_user_token(conn) do
    if current_user = conn.assigns[:current_user] do
      token = Phoenix.Token.sign(conn, "user", current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end
end
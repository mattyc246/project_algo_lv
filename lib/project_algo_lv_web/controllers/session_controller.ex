defmodule ProjectAlgoLvWeb.SessionController do
  use ProjectAlgoLvWeb, :controller

  alias ProjectAlgoLv.Accounts

  def new(conn, _params) do
    if conn.assigns.current_user do
      conn
      |> redirect(to: Routes.dashboard_index_path(conn, :index))
    else
      render(conn, "new.html")
    end
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Accounts.authenticate_by_email_and_password(email, password) do
      {:ok, user} ->
        conn
        |> ProjectAlgoLvWeb.Auth.login(user)
        |> put_flash(:info, "You have been logged in successfully!")
        |> redirect(to: Routes.dashboard_index_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> ProjectAlgoLvWeb.Auth.logout()
    |> put_flash(:info, "Logged out successfully")
    |> redirect(to: Routes.home_path(conn, :index))
  end
end
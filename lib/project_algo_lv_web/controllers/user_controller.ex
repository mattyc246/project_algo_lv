defmodule ProjectAlgoLvWeb.UserController do
  use ProjectAlgoLvWeb, :controller

  alias ProjectAlgoLv.Accounts
  alias ProjectAlgoLv.Accounts.User
  alias ProjectAlgoLv.Accounts.Invitation

  def new(conn, %{"invite_code" => invite_code}) do
    case Accounts.get_valid_invitation(%{invite_code: invite_code}) do
      %Invitation{} = invitation ->
        changeset = Accounts.change_user(%User{}, %{})
        conn
        |> assign(:page_title, "Register")
        |> render("new.html", changeset: changeset, invitation: invitation)
      nil ->
        conn
        |> put_flash(:error, "Invalid invitation")
        |> redirect(to: Routes.home_path(conn, :index))
    end
  end

  def create(conn, %{"user" => user_params, "invite_code" => invite_code}) do
    invitation = Accounts.get_invitation_by(%{invite_code: invite_code})
    case Accounts.create_user(user_params) do
      {:ok, _user} ->
        Accounts.update_invitation(invitation, %{invites: invitation.invites - 1})
         conn
         |> put_flash(:info, "User created successfully")
         |> redirect(to: Routes.home_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("new.html", changeset: changeset, invitation: invitation)
    end
  end
end
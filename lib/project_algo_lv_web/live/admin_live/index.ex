defmodule ProjectAlgoLvWeb.AdminLive.Index do
  use ProjectAlgoLvWeb, :live_view

  alias ProjectAlgoLv.Accounts

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(session, socket)
      |> assign(:users, list_user_accounts())}
  end

  @impl true
  def handle_event("remove_role", %{"user_id" => user_id, "role" => role}, socket) do
    user = Accounts.get_user!(user_id)
    case Accounts.remove_user_role(user, role) do
      {:ok, _} ->
        {:noreply, socket
          |> assign(:users, list_user_accounts())}
      {:error, _} ->
        {:noreply, socket
          |> put_flash(:error, "Unable to update role")}
    end
  end

  @impl true
  def handle_event("add_role", %{"user_id" => user_id, "role" => role}, socket) do
    user = Accounts.get_user!(user_id)
    case Accounts.add_user_role(user, role) do
      {:ok, _} ->
        {:noreply, socket
          |> assign(:users, list_user_accounts())}
      {:error, _} ->
        {:noreply, socket
          |> put_flash(:error, "Unable to update role")}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Admin")
    |> assign(:page_icon, "/icons/settings-black.png")
  end

  defp list_user_accounts do
    Accounts.list_users_and_memberships()
  end
end

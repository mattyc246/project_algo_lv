defmodule ProjectAlgoLvWeb.UserLive.New do
  use ProjectAlgoLvWeb, :live_view

  alias ProjectAlgoLv.Accounts
  alias ProjectAlgoLv.Accounts.User
  alias ProjectAlgoLv.Accounts.Invitation

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"invite_code" => invite_code}, _, socket) do
    case Accounts.get_valid_invitation(%{invite_code: invite_code}) do
      %Invitation{} = invitation ->
        {:noreply,
        socket
        |> assign(:page_title, page_title(socket.assigns.live_action))
        |> assign(:user, %User{})}
      nil ->
        {:noreply,
        socket
        |> put_flash(:error, "Invalid invitation")
        |> redirect(to: Routes.home_path(socket, :index))}
    end
  end

  defp page_title(:new), do: "Register"
end
defmodule ProjectAlgoLvWeb.UserLive.Session do
  use ProjectAlgoLvWeb, :live_view

  alias ProjectAlgoLv.Accounts
  alias ProjectAlgoLv.Accounts.User

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:user, %User{})}
  end

  defp page_title(:new), do: "Login"
end
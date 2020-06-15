defmodule ProjectAlgoLvWeb.DashboardLive.Index do
  use ProjectAlgoLvWeb, :live_view

  alias ProjectAlgoLv.Accounts
  alias ProjectAlgoLv.Accounts.User

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(session, socket)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Dashboard")
    |> assign(:page_icon, "/icons/menu-black.png")
  end

end

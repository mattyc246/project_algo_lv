defmodule ProjectAlgoLvWeb.AccountsLive.Index do
  use ProjectAlgoLvWeb, :live_view

  alias ProjectAlgoLv.Accounts
  alias ProjectAlgoLv.Accounts.User

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Accounts")
    |> assign(:page_icon, "/icons/graph-black.png")
  end

end

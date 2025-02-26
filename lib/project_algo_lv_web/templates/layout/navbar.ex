defmodule ProjectAlgoLvWeb.Navbar do
  use ProjectAlgoLvWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {:ok, socket
      |> assign(:current_user, assigns.current_user)
      |> assign(:expanded, false)}
  end

  def mount(_params, _session, socket) do
    {:ok, socket
      |> assign(:expanded, false)}
  end

  @impl true
  def handle_event("expand", _params, socket) do
    {:noreply, assign(socket, :expanded, !socket.assigns.expanded)}
  end
end
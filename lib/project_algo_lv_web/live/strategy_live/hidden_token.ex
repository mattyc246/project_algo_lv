defmodule ProjectAlgoLvWeb.StrategyLive.HiddenTokenComponent do
  use ProjectAlgoLvWeb, :live_component

  @impl true
  def update(%{token: token} = assigns, socket) do
    {:ok,
      socket
      |> assign(:revealed, false)
      |> assign(:token, token)}
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("reveal", _params, socket) do
    {:noreply, assign(socket, :revealed, true)}
  end
end

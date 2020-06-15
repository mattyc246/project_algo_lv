defmodule ProjectAlgoLvWeb.StrategyLive.New do
  use ProjectAlgoLvWeb, :live_view

  alias ProjectAlgoLv.Trades
  alias ProjectAlgoLv.Trades.Strategy

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(session, socket)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Strategy")
    |> assign(:page_icon, "/icons/calculator-black.png")
    |> assign(:strategy, %Strategy{})
  end
end

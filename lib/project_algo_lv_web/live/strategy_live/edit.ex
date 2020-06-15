defmodule ProjectAlgoLvWeb.StrategyLive.Edit do
  use ProjectAlgoLvWeb, :live_view

  alias ProjectAlgoLv.Trades
  alias ProjectAlgoLv.Trades.Strategy

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(session, socket)}
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, id)}
  end

  defp apply_action(socket, :edit, id) do
    strategy = Trades.get_strategy!(id)
    socket
    |> assign(:page_title, "Edit #{strategy.name}")
    |> assign(:page_icon, "/icons/calculator-black.png")
    |> assign(:strategy, strategy)
  end
end

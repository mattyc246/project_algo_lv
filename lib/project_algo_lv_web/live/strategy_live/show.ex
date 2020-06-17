defmodule ProjectAlgoLvWeb.StrategyLive.Show do
  use ProjectAlgoLvWeb, :live_view
  alias ProjectAlgoLvWeb.HistoricalHelper

  alias ProjectAlgoLv.Trades

  @impl true
  def mount(%{"id" => id}, session, socket) do
    :timer.send_interval(60_000, self(), :poll_data)
    strategy = Trades.get_strategy!(id)
    {:ok,
      assign_defaults(session, socket)
      |> assign(:last_updated, Timex.format!(DateTime.utc_now, "{YYYY}/{M}/{D} - {h24}:{m}:{s}"))
      |> assign(:chart_data, Jason.encode!(HistoricalHelper.get_strategy_balances(strategy.access_token)))
      |> assign(:historical_data, HistoricalHelper.get_strategy_records(strategy.access_token))}
  end

  def handle_info(:poll_data, socket) do
    strategy = Trades.get_strategy!(socket.assigns.strategy.id)
    {:noreply,
      assign(socket, :historical_data, HistoricalHelper.get_strategy_records(strategy.access_token))
      |> assign(:last_updated, Timex.format!(DateTime.utc_now, "{YYYY}/{M}/{D} - {h24}:{m}:{s}"))
      |> assign(:chart_data, Jason.encode!(HistoricalHelper.get_strategy_balances(strategy.access_token)))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    strategy = Trades.get_strategy!(id)
    {:noreply,
     socket
     |> assign(:page_title, strategy.name)
     |> assign(:page_icon, "/icons/calculator-black.png")
     |> assign(:strategy, strategy)}
  end

end

defmodule ProjectAlgoLvWeb.StrategyLive.Show do
  use ProjectAlgoLvWeb, :live_view
  alias ProjectAlgoLvWeb.DynamoHelper

  alias ProjectAlgoLv.Trades

  @impl true
  def mount(%{"id" => id}, session, socket) do
    # :timer.send_interval(120_000, self(), :poll_data)
    {:ok,
      assign_defaults(session, socket)
      |> assign(:historical_data, Jason.encode!(%{one: 2}))}
  end

  def handle_info(:poll_data, socket) do
    {:noreply, assign(socket, :historical_data, Jason.encode!(%{one: 2}))}
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

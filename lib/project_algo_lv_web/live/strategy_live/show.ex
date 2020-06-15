defmodule ProjectAlgoLvWeb.StrategyLive.Show do
  use ProjectAlgoLvWeb, :live_view

  alias ProjectAlgoLv.Trades

  @impl true
  def mount(_params, session, socket) do
    :timer.send_interval(5_000, self(), :next_data)
    date_now = DateTime.utc_now
    data = Jason.encode!(%{date_now => Enum.random(1..200)})
    {:ok,
      assign_defaults(session, socket)
      |> assign(:historical_data, data)}
  end

  def handle_info(:next_data, socket) do
    date_now = DateTime.utc_now
    data = Map.put(Jason.decode!(socket.assigns.historical_data), date_now, Enum.random(1..200))
    {:noreply, assign(socket, :historical_data, Jason.encode!(data))}
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

  defp fetch_historical_data() do

  end
end

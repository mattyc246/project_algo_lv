defmodule ProjectAlgoLvWeb.StrategyLive.ChartComponent do
  use ProjectAlgoLvWeb, :live_component

  @impl true
  def update(%{historical_data: historical_data} = assigns, socket) do
    {:ok,
      socket
      |> assign(:last_updated, DateTime.utc_now)
      |> assign(:historical_data, historical_data)}
  end

  def mount(session, socket) do
    {:ok,
      assign_defaults(session, socket)}
  end
end
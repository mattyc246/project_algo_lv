defmodule ProjectAlgoLvWeb.StrategyLive.ChartComponent do
  use ProjectAlgoLvWeb, :live_component

  @impl true
  def update(%{chart_data: chart_data} = assigns, socket) do
    {:ok,
      socket
      |> assign(:chart_data, chart_data)}
  end

  def mount(session, socket) do
    {:ok,
      assign_defaults(session, socket)}
  end
end
defmodule ProjectAlgoLvWeb.DashboardLive.ChartComponent do
  use ProjectAlgoLvWeb, :live_component

  @impl true
  def update(%{balances: balances} = assigns, socket) do
    {:ok,
      socket
      |> assign(:last_updated, DateTime.utc_now)
      |> assign(:balances, balances)}
  end

  def mount(session, socket) do
    {:ok,
      assign_defaults(session, socket)}
  end
end
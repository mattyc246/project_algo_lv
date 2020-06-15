defmodule ProjectAlgoLvWeb.StrategyLive.Show do
  use ProjectAlgoLvWeb, :live_view

  alias ProjectAlgoLv.Trades

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:strategy, Trades.get_strategy!(id))}
  end

  defp page_title(:show), do: "Show Strategy"
  defp page_title(:edit), do: "Edit Strategy"
end

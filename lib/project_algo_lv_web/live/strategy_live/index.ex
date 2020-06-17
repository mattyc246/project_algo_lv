defmodule ProjectAlgoLvWeb.StrategyLive.Index do
  use ProjectAlgoLvWeb, :live_view

  alias ProjectAlgoLv.Trades
  alias ProjectAlgoLv.Accounts
  alias ProjectAlgoLv.Trades.Strategy

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(session, socket)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Strategy - Edit")
    |> assign(:strategy, Trades.get_strategy!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Strategy - New")
    |> assign(:strategy, %Strategy{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Strategies")
    |> assign(:page_icon, "/icons/calculator-black.png")
    |> assign(:strategies, list_user_strategies(socket.assigns.current_user.id))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    strategy = Trades.get_strategy!(id)
    {:ok, _} = Trades.delete_strategy(strategy)

    {:noreply, assign(socket, :strategies, list_user_strategies(socket.assigns.current_user.id))}
  end

  defp list_user_strategies(user_id) do
    user = Accounts.get_user!(user_id)
    Trades.list_user_strategies(user)
  end
end

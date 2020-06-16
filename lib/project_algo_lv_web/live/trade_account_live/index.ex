defmodule ProjectAlgoLvWeb.TradeAccountLive.Index do
  use ProjectAlgoLvWeb, :live_view

  alias ProjectAlgoLv.Trades
  alias ProjectAlgoLv.Trades.TradeAccount

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(session, socket)
      |> assign(:trade_accounts, list_trade_accounts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Trade Accounts")
    |> assign(:page_icon, "/icons/graph-black.png")
    |> assign(:trade_account, %TradeAccount{})
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    trade_account = Trades.get_trade_account!(id)
    {:ok, _} = Trades.delete_trade_account(trade_account)

    {:noreply, assign(socket, :trade_accounts, list_trade_accounts())}
  end

  defp list_trade_accounts do
    Trades.list_trade_accounts()
  end
end

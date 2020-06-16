defmodule ProjectAlgoLvWeb.TradeAccountLive.Index do
  use ProjectAlgoLvWeb, :live_view

  alias ProjectAlgoLv.Accounts
  alias ProjectAlgoLv.Trades
  alias ProjectAlgoLv.Accounts.User
  alias ProjectAlgoLv.Trades.TradeAccount

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(session, socket)
      |> assign(:trade_accounts, list_trade_accounts(session["user_id"]))}
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

    {:noreply, assign(socket, :trade_accounts, list_trade_accounts(socket.assigns.current_user))}
  end

  defp list_trade_accounts(user_id) do
    user = Accounts.get_user!(user_id)
    Trades.list_user_trade_accounts(user)
  end
end

defmodule ProjectAlgoLvWeb.DashboardLive.Index do
  use ProjectAlgoLvWeb, :live_view

  alias ProjectAlgoLvWeb.HistoricalHelper
  alias ProjectAlgoLv.Accounts
  alias ProjectAlgoLv.Trades

  @impl true
  def mount(_params, session, socket) do
    :timer.send_interval(600_000, self(), :user_balances)
    user = Accounts.get_user!(session["user_id"])
    accounts = for acc <- Trades.list_user_trade_accounts(user), do: acc.id
    {:ok,
      assign_defaults(session, socket)
      |> assign(:balances, Jason.encode!(HistoricalHelper.hourly_wallet_balance(accounts)))
      |> assign(:combined_balance, HistoricalHelper.combined_account_balance(accounts))
      |> assign(:first_last, HistoricalHelper.daily_first_last(accounts))
      |> assign(:last_updated, Timex.format!(DateTime.utc_now, "{YYYY}/{M}/{D} - {h24}:{m}:{s}"))}
  end

  @impl true
  def handle_info(:user_balances, socket) do
    accounts = for acc <- Trades.list_user_trade_accounts(socket.assigns.current_user), do: acc.id
    {:noreply,
      assign(socket, :balances, Jason.encode!(HistoricalHelper.hourly_wallet_balance(accounts)))
      |> assign(:combined_balance, HistoricalHelper.combined_account_balance(accounts))
      |> assign(:first_last, HistoricalHelper.daily_first_last(accounts))
      |> assign(:last_updated, Timex.format!(DateTime.utc_now, "{YYYY}/{M}/{D} - {h24}:{m}:{s}"))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Dashboard")
    |> assign(:page_icon, "/icons/menu-black.png")
  end

end

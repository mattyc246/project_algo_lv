defmodule ProjectAlgoLvWeb.TradeAccountLive.FormComponent do
  use ProjectAlgoLvWeb, :live_component

  alias ProjectAlgoLv.Trades

  @impl true
  def update(%{trade_account: trade_account} = assigns, socket) do
    changeset = Trades.change_trade_account(trade_account)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"trade_account" => trade_account_params}, socket) do
    changeset =
      socket.assigns.trade_account
      |> Trades.change_trade_account(trade_account_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"trade_account" => trade_account_params}, socket) do
    save_trade_account(socket, socket.assigns.action, trade_account_params)
  end

  defp save_trade_account(socket, :edit, trade_account_params) do
    case Trades.update_trade_account(socket.assigns.trade_account, trade_account_params) do
      {:ok, _trade_account} ->
        {:noreply,
         socket
         |> put_flash(:info, "Trade account updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_trade_account(socket, :new, trade_account_params) do
    case Trades.create_trade_account(socket.assigns.user, trade_account_params) do
      {:ok, _trade_account} ->
        {:noreply,
         socket
         |> put_flash(:info, "Trade account created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

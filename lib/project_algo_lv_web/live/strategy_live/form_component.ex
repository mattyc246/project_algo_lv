defmodule ProjectAlgoLvWeb.StrategyLive.FormComponent do
  use ProjectAlgoLvWeb, :live_component

  alias ProjectAlgoLv.Trades

  @impl true
  def update(%{strategy: strategy} = assigns, socket) do
    changeset = Trades.change_strategy(strategy)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"strategy" => strategy_params}, socket) do
    changeset =
      socket.assigns.strategy
      |> Trades.change_strategy(strategy_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"strategy" => strategy_params}, socket) do
    save_strategy(socket, socket.assigns.action, strategy_params)
  end

  defp save_strategy(socket, :edit, strategy_params, _user) do
    case Trades.update_strategy(socket.assigns.strategy, strategy_params) do
      {:ok, _strategy} ->
        {:noreply,
         socket
         |> put_flash(:info, "Strategy updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_strategy(socket, :new, strategy_params) do
    case Trades.create_strategy(strategy_params) do
      {:ok, _strategy} ->
        {:noreply,
         socket
         |> put_flash(:info, "Strategy created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

defmodule ProjectAlgoLvWeb.HistoricalDatumController do
    use ProjectAlgoLvWeb, :controller
    alias ExAws.Dynamo
    alias ProjectAlgoLv.Trades

    def create(conn, %{"data" => transaction_params}) do
        strategy = Trades.get_strategy_by!(%{access_token: transaction_params["strategy_access_token"]})

        historical_datum = %{
            strategy_access_token: transaction_params["strategy_access_token"],
            account_id: strategy.trade_account_id,
            symbol: transaction_params["symbol"],
            positions: transaction_params["positions"],
            realised_pnl: transaction_params["realised_pnl"],
            average_entry_price: transaction_params["average_entry_price"] / 1,
            margin_balance: transaction_params["margin_balance"],
            wallet_balance: transaction_params["wallet_balance"],
            last_price: transaction_params["last_price"] / 1,
            created_at: DateTime.to_iso8601(DateTime.utc_now)
        }
        with {:ok, _result} <- Dynamo.put_item(System.get_env("DYNAMODB_TABLE"), historical_datum) |> ExAws.request() do
            conn
            |> put_status(:created)
            |> json(%{status: true})
        end
    end

end

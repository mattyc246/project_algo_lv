defmodule ProjectAlgoLvWeb.HistoricalDatumController do
    use ProjectAlgoLvWeb, :controller
    alias ExAws.Dynamo

    def create(conn, %{"data" => transaction_params}) do
        last_price = transaction_params["last_price"] / 1
        wallet_balance_usd =
          transaction_params["wallet_balance"]
          |> Decimal.div(100_000_000)
          |> Decimal.mult(Decimal.from_float(last_price))
          |> Decimal.round(2, :down)
          |> Decimal.to_float()

        margin_balance_usd =
          transaction_params["margin_balance"]
          |> Decimal.div(100_000_000)
          |> Decimal.mult(Decimal.from_float(last_price))
          |> Decimal.round(2, :down)
          |> Decimal.to_float()

        realised_pnl_usd =
          transaction_params["realised_pnl"]
          |> Decimal.div(100_000_000)
          |> Decimal.mult(Decimal.from_float(last_price))
          |> Decimal.round(2, :down)
          |> Decimal.to_float()

        historical_datum = %{
            strategy_access_token: transaction_params["strategy_access_token"],
            symbol: transaction_params["symbol"],
            positions: transaction_params["positions"],
            realised_pnl: realised_pnl_usd,
            average_entry_price: transaction_params["average_entry_price"] / 1,
            margin_balance: margin_balance_usd,
            wallet_balance: wallet_balance_usd,
            last_price: transaction_params["last_price"] / 1,
            created_at: DateTime.to_string(DateTime.utc_now)
        }
        with {:ok, _result} <- Dynamo.put_item("historical_datum", historical_datum) |> ExAws.request() do
            conn
            |> put_status(:created)
            |> json(%{status: true})
        end
    end

end

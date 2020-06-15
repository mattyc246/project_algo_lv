defmodule ProjectAlgoLvWeb.HistoricalDatum do
    @derive [ExAws.Dynamo.Encodable]
    defstruct [:average_entry_price, :strategy_access_token, :created_at, :last_price, :wallet_balance, :margin_balance, :positions, :realised_pnl, :symbol]
end

defmodule ProjectAlgoLvWeb.DynamoHelper do
  alias ProjectAlgoLv.Trades
  alias ExAws.Dynamo
  alias ProjectAlgoLvWeb.HistoricalDatum

  def fetch_historical_data(id) do
    strategy = Trades.get_strategy!(id)
    items = Dynamo.scan(System.get_env("DYNAMODB_TABLE"), expression_attribute_values: [strategy_access_token: strategy.access_token], filter_expression: "strategy_access_token = :strategy_access_token")|> ExAws.request! |> Dynamo.decode_item(as: HistoricalDatum) |> IO.inspect()
    items
  end

  def fetch_sorted_historical_data(id) do
    strategy = Trades.get_strategy!(id)
    items = Dynamo.scan(System.get_env("DYNAMODB_TABLE"), expression_attribute_values: [strategy_access_token: strategy.access_token], filter_expression: "strategy_access_token = :strategy_access_token")|> ExAws.request! |> Dynamo.decode_item(as: HistoricalDatum) |> IO.inspect()
    map = Enum.reduce items, %{}, fn hd, data ->
      Map.put(data, hd.created_at, hd.margin_balance)
    end
  end

  def fetch_user_data(user_id) do

  end
end
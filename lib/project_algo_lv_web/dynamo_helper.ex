defmodule ProjectAlgoLvWeb.DynamoHelper do
  alias ProjectAlgoLv.Trades
  alias ExAws.Dynamo
  alias ProjectAlgoLv.Trades.HistoricalDatum

  def fetch_all_data do
    Dynamo.scan(System.get_env("DYNAMODB_TABLE"))|> ExAws.request! |> Dynamo.decode_item(as: HistoricalDatum)
  end

  def fetch_historical_data(id) do
    strategy = Trades.get_strategy!(id)
    items = get_historical_data_by_token(strategy.access_token)
  end

  def fetch_sorted_historical_data(id) do
    strategy = Trades.get_strategy!(id)
    items = get_historical_data_by_token(strategy.access_token)
    map = Enum.reduce items, %{}, fn hd, data ->
      Map.put(data, hd.created_at, hd.margin_balance)
    end
  end

  def fetch_user_data(user) do
    strategies = Trades.list_user_strategies(user)
  end

  defp get_historical_data_by_token(token) do
    Dynamo.scan(System.get_env("DYNAMODB_TABLE"), expression_attribute_values: [strategy_access_token: token], filter_expression: "strategy_access_token = :strategy_access_token")|> ExAws.request! |> Dynamo.decode_item(as: HistoricalDatum)
  end
end
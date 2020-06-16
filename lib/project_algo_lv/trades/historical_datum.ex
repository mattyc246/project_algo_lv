defmodule ProjectAlgoLv.Trades.HistoricalDatum do
    @derive [ExAws.Dynamo.Encodable]
    defstruct [:average_entry_price, :strategy_access_token, :created_at, :last_price, :wallet_balance, :margin_balance, :positions, :realised_pnl, :symbol]
end
defmodule ProjectAlgoLv.Trades.TradeAccount do
  use Ecto.Schema
  import Ecto.Changeset

  schema "trade_accounts" do
    field :name, :string
    field :platform, :string

    timestamps()
  end

  @doc false
  def changeset(trade_account, attrs) do
    trade_account
    |> cast(attrs, [:name, :platform])
    |> validate_required([:name, :platform])
    |> unique_constraint(:name)
  end
end

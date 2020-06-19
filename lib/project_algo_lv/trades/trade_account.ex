defmodule ProjectAlgoLv.Trades.TradeAccount do
  use Ecto.Schema
  import Ecto.Changeset

  alias ProjectAlgoLv.Accounts.User
  alias ProjectAlgoLv.Trades.Strategy

  schema "trade_accounts" do
    field :name, :string
    belongs_to :user, User
    has_many :strategies, Strategy

    timestamps()
  end

  @doc false
  def changeset(trade_account, attrs) do
    trade_account
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end

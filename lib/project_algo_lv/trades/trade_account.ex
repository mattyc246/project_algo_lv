defmodule ProjectAlgoLv.Trades.TradeAccount do
  use Ecto.Schema
  import Ecto.Changeset

  alias ProjectAlgoLv.Accounts.User
  alias ProjectAlgoLv.Trades.Strategy

  schema "trade_accounts" do
    field :name, :string
    field :platform, :string
    belongs_to :user, User
    has_many :strategies, Strategy

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

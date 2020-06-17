defmodule ProjectAlgoLv.Trades.Strategy do
  use Ecto.Schema
  import Ecto.Changeset
  alias ProjectAlgoLv.Trades.TradeAccount

  schema "strategies" do
    field :access_token, :string
    field :description, :string
    field :name, :string
    belongs_to :trade_account, TradeAccount

    timestamps()
  end

  @doc false
  def create_changeset(strategy, attrs) do
    strategy
    |> cast(attrs, [:name, :description, :access_token, :trade_account_id])
    |> gen_access_token()
    |> validate_required([:name, :access_token, :trade_account_id])
  end

  def changeset(strategy, attrs) do
    strategy
    |> cast(attrs, [:name, :description, :access_token, :trade_account_id])
    |> validate_required([:name, :access_token, :trade_account_id])
  end

  defp gen_access_token(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        changeset
        |> cast(%{access_token: :crypto.strong_rand_bytes(42) |> Base.encode64 |> binary_part(0, 42)}, [:access_token])
      _ ->
        changeset
    end
  end
end

defmodule ProjectAlgoLv.Memberships.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias ProjectAlgoLv.Memberships.Membership

  schema "transactions" do
    field :amount_paid, :integer
    field :billing_details, :map
    field :payment_created_at, :utc_datetime
    field :payment_id, :string
    field :payment_method_type, :string
    belongs_to :membership, Membership

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:amount_paid, :payment_id, :payment_created_at, :payment_method_type, :billing_details])
    |> validate_required([:amount_paid, :payment_id, :payment_created_at, :payment_method_type, :billing_details])
  end
end

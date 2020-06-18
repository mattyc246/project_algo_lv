defmodule ProjectAlgoLv.Memberships.Membership do
  use Ecto.Schema
  import Ecto.Changeset
  alias ProjectAlgoLv.Accounts.User

  schema "memberships" do
    field :end_date, :utc_datetime
    field :start_date, :utc_datetime
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(membership, attrs) do
    membership
    |> cast(attrs, [:start_date, :end_date])
    |> validate_required([:start_date, :end_date])
  end
end

defmodule ProjectAlgoLv.Accounts.Invitation do
  use Ecto.Schema
  import Ecto
  import Ecto.Changeset
  alias ProjectAlgoLv.Accounts.User

  schema "invitations" do
    field :invite_code, Ecto.UUID, autogenerate: true
    field :invites, :integer, default: 5
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(invitation, attrs) do
    invitation
    |> cast(attrs, [:invite_code, :invites])
    |> validate_required([:invites])
  end

end

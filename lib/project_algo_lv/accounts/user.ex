defmodule ProjectAlgoLv.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias ProjectAlgoLv.Trades.Strategy
  alias ProjectAlgoLv.Memberships.Membership

  schema "users" do
    field :email, :string
    field :name, :string
    field :roles, {:array, :string}, default: ["member"]
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    has_many :strategies, Strategy
    has_many :memberships, Membership

    timestamps()
  end

  def hash_pass(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        changeset
        |> cast(%{password_hash: Pbkdf2.hash_pwd_salt(pass)}, [:password_hash])
      _ ->
        changeset
    end
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :password_confirmation])
    |> validate_confirmation(:password)
    |> validate_length(:password, min: 6, max: 24)
    |> validate_format(:email, ~r/(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)/)
    |> unique_constraint(:email)
  end

  def add_role_changeset(user, role) do
    user
    |> change()
    |> put_change(:roles, [role | user.roles])
  end

  def remove_role_changeset(user, role) do
    user
    |> change()
    |> put_change(:roles, List.delete(user.roles, role))
  end

  def auth_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> hash_pass()
    |> validate_required([:name, :email, :password, :password_confirmation])
  end
end

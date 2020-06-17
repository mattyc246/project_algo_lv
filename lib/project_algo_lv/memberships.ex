defmodule ProjectAlgoLv.Memberships do
  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias ProjectAlgoLv.Repo
  alias ProjectAlgoLv.Accounts.User
  alias ProjectAlgoLv.Memberships.Membership
  alias ProjectAlgoLv.Memberships.Transaction


  # Membership
  def list_memberships do
    Repo.all(Membership)
  end

  def list_user_memberships(id) do
    from(m in Membership, where: m.user_id == ^id)
    |> Repo.all()
  end

  def get_membership_by(params), do: Repo.get_by(Membership, params)

  # get current active membership, if no return nil
  def get_current_membership(user_id, date) do
    from(m in Membership, where: m.user_id == ^user_id and m.end_date > ^date, select: %{start_date: m.start_date, end_date: m.end_date})
    |> Repo.one()
  end

  def create_membership(%User{} = user, attrs \\ %{}) do
    %Membership{}
    |> Membership.changeset(attrs)
    |> put_assoc(:user, user)
    |> Repo.insert()
  end

  # Transaction
  def list_transactions do
    Repo.all(Transaction)
  end

  def get_transaction_by(params), do: Repo.get_by(Transaction, params)

  def get_transaction!(id), do: Repo.get!(Transaction, id)

  def create_transaction(%Membership{} = membership, attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> put_assoc(:membership, membership)
    |> Repo.insert()
  end
end
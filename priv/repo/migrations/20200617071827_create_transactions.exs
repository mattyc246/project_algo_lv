defmodule ProjectAlgoLv.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :amount_paid, :integer
      add :payment_id, :string
      add :payment_created_at, :utc_datetime
      add :payment_method_type, :string
      add :billing_details, :map
      add :membership_id, references(:memberships, on_delete: :nothing)

      timestamps()
    end

    create index(:transactions, [:membership_id])
  end
end

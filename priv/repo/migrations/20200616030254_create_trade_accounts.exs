defmodule ProjectAlgoLv.Repo.Migrations.CreateTradeAccounts do
  use Ecto.Migration

  def change do
    create table(:trade_accounts) do
      add :name, :string, null: false
      add :platform, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
    
    create index(:trade_accounts, [:user_id])
    create unique_index(:trade_accounts, [:name])
  end
end

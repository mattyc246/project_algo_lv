defmodule ProjectAlgoLv.Repo.Migrations.CreateTradeAccounts do
  use Ecto.Migration

  def change do
    create table(:trade_accounts) do
      add :name, :string, null: false
      add :platform, :string, null: false

      timestamps()
    end
    create unique_index(:trade_accounts, [:name])
  end
end

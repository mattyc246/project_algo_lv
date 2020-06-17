defmodule ProjectAlgoLv.Repo.Migrations.CreateStrategies do
  use Ecto.Migration

  def change do
    create table(:strategies) do
      add :name, :string, null: false
      add :description, :text
      add :access_token, :string, null: false
      add :trade_account_id, references(:trade_accounts, on_delete: :delete_all)

      timestamps()
    end

    create index(:strategies, [:trade_account_id])
  end
end

defmodule ProjectAlgoLv.Repo.Migrations.RemovePlatformFieldFromTradeAccounts do
  use Ecto.Migration

  def change do
    alter table(:trade_accounts) do
      remove :platform, :string
    end
  end
end

defmodule ProjectAlgoLv.Repo.Migrations.CreateInvitations do
  use Ecto.Migration

  def change do
    create table(:invitations) do
      add :invite_code, :uuid, null: false
      add :invites, :integer, default: 5
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:invitations, [:invite_code])
  end
end

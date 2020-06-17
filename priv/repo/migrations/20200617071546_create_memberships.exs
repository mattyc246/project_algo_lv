defmodule ProjectAlgoLv.Repo.Migrations.CreateMemberships do
  use Ecto.Migration

  def change do
    create table(:memberships) do
      add :start_date, :utc_datetime
      add :end_date, :utc_datetime
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:memberships, [:user_id])
  end
end

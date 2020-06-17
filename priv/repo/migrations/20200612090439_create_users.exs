defmodule ProjectAlgoLv.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :roles, {:array, :string}, default: ["member"]
      add :password_hash, :string

      timestamps()
    end

  end
end

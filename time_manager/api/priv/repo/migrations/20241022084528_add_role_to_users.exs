defmodule TimeManager.Repo.Migrations.AddRoleToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :role, :string, default: "user"
    end
    alter table(:users) do
      add :password_hash, :string
    end
  end
end

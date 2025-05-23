defmodule TimeManager.Repo.Migrations.CreateUsersTeams do
  use Ecto.Migration

  def change do
    create table(:users_teams) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :team_id, references(:teams, on_delete: :delete_all)
    end

    # Index unique pour éviter les doublons
    create unique_index(:users_teams, [:user_id, :team_id])
  end
end

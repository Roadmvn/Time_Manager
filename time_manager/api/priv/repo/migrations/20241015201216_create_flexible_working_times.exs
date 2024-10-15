defmodule TimeManager.Repo.Migrations.CreateFlexibleWorkingTimes do
  use Ecto.Migration

  def change do
    create table(:flexible_working_times) do
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime
      add :night_hours, :float
      add :overtime_hours, :float
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:flexible_working_times, [:user_id])
  end
end

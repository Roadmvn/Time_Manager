defmodule TimeManager.Repo.Migrations.CreateWorkingTimes do
  use Ecto.Migration

  def change do
    create table(:working_times) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :start, :naive_datetime, null: false
      add :end, :naive_datetime, null: false

      add :day_hours, :float, default: 0.0
      add :night_hours, :float, default: 0.0
      add :overtime_hours, :float, default: 0.0

      timestamps()
    end

    create index(:working_times, [:user_id])
  end
end

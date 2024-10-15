defmodule TimeManager.Repo.Migrations.CreateNightShifts do
  use Ecto.Migration

  def change do
    create table(:night_shifts) do
      add :shift_date, :date
      add :consecutive_nights, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:night_shifts, [:user_id])
  end
end

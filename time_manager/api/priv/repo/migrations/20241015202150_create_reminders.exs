defmodule TimeManager.Repo.Migrations.CreateReminders do
  use Ecto.Migration

  def change do
    create table(:reminders) do
      add :message, :string
      add :sent_at, :utc_datetime
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:reminders, [:user_id])
  end
end

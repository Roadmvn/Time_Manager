defmodule TimeManager.Repo.Migrations.CreateTutorials do
  use Ecto.Migration

  def change do
    create table(:tutorials) do
      add :title, :string
      add :content, :text
      add :video_url, :string

      timestamps(type: :utc_datetime)
    end
  end
end

defmodule TimeManager.Tasks do
  import Ecto.Query
  alias TimeManager.Repo
  alias TimeManager.Tasks.Task

  def list_tasks do
    Repo.all(Task)
  end

  def get_task!(id), do: Repo.get!(Task, id)

  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  def list_user_tasks(user_id) do
    Task
    |> where([t], t.user_id == ^user_id)
    |> Repo.all()
  end
end
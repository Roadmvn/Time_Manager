defmodule TimeManager.Teams do
  import Ecto.Query
  alias TimeManager.Repo
  alias TimeManager.Teams.Team

  def list_teams do
    Repo.all(Team)
  end

  def get_team(id) do
    case Repo.get(Team, id) do
      nil -> {:error, :not_found}
      team -> {:ok, team}
    end
  end

  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  def add_team_member(team, user) do
    team = Repo.preload(team, :users)
    team
    |> Team.changeset(%{})
    |> Ecto.Changeset.put_assoc(:users, [user | team.users])
    |> Repo.update()
  end

  def remove_team_member(team, user) do
    team
    |> Repo.preload(:users)
    |> Team.changeset_remove_member(user)
    |> Repo.update()
  end
end

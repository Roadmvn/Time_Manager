defmodule TimeManagerWeb.TeamJSON do
  def index(%{teams: teams}) do
    %{data: for(team <- teams, do: data(team))}
  end

  def show(%{team: team}) do
    %{data: data(team)}
  end

  def team_clock(%{results: results}) do
    %{data: results}
  end

  def members_status(%{members: members}) do
    %{data: members}
  end

  defp data(team) do
    %{
      id: team.id,
      name: team.name,
      created_at: team.inserted_at
    }
  end

  def team_json(team) do
    %{
      id: team.id,
      name: team.name,
      inserted_at: team.inserted_at,
      updated_at: team.updated_at,
      members: case team.users do
        %Ecto.Association.NotLoaded{} -> []
        nil -> []
        users -> Enum.map(users, fn user -> %{
          id: user.id,
          username: user.username,
          email: user.email
        } end)
      end
    }
  end
end

defmodule TimeManagerWeb.TeamController do
  use TimeManagerWeb, :controller

  alias TimeManager.Teams
  alias TimeManager.Accounts
  alias TimeManager.Repo

  def index(conn, _params) do
    teams = Teams.list_teams()
    |> Repo.preload(:users)  # Préchargement des utilisateurs
    render(conn, :index, teams: teams)
  end

  def create(conn, %{"team" => team_params}) do
    case Teams.create_team(team_params) do
      {:ok, team} ->
        conn
        |> put_status(:created)
        |> render(:show, team: team)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, team} <- Teams.get_team(id) do
      team = Repo.preload(team, :users)
      render(conn, :show, team: team)
    end
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    with {:ok, team} <- Teams.get_team(id),
         {:ok, updated_team} <- Teams.update_team(team, team_params) do
      updated_team = Repo.preload(updated_team, :users)  # Préchargement des utilisateurs
      render(conn, :show, team: updated_team)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, team} <- Teams.get_team(id),
         {:ok, _deleted} <- Teams.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end

  def clock(conn, %{"id" => team_id}) do
    with {:ok, team} <- Teams.get_team(team_id),
         {:ok, results} <- Teams.clock_team(team) do
      conn
      |> put_status(:ok)
      |> render(:team_clock, results: results)
    end
  end

  def get_members_status(conn, %{"id" => team_id}) do
    with {:ok, team} <- Teams.get_team(team_id),
         {:ok, members} <- Teams.get_team_members_status(team) do
      conn
      |> put_status(:ok)
      |> render(:members_status, members: members)
    end
  end

  def add_member(conn, %{"team_id" => team_id, "user_id" => user_id}) do
    with {:ok, team} <- Teams.get_team(team_id),
         {:ok, user} <- Accounts.get_user(user_id),
         {:ok, updated_team} <- Teams.add_team_member(team, user) do
      conn
      |> put_status(:ok)
      |> render(:show, team: updated_team)
    else
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Team or user not found"})
      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Unable to add member to team"})
    end
  end

  def remove_member(conn, %{"team_id" => team_id, "user_id" => user_id}) do
    with {:ok, team} <- Teams.get_team(team_id),
         {:ok, user} <- Accounts.get_user(user_id),
         {:ok, _updated_team} <- Teams.remove_team_member(team, user) do
      send_resp(conn, :no_content, "")
    end
  end

  defp format_changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end

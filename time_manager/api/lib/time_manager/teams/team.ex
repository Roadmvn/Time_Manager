defmodule TimeManager.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    many_to_many :users, TimeManager.Accounts.User, join_through: "users_teams"

    timestamps()
  end

  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def changeset_add_member(team, attrs) do
    team
    |> cast(attrs, [])
    |> cast_assoc(:users)
  end

  def changeset_remove_member(team, user) do
    team
    |> change()
    |> put_assoc(:users, Enum.filter(team.users, &(&1.id != user.id)))
  end
end

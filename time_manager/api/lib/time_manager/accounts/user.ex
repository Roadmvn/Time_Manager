defmodule TimeManager.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :username, :email, :role, :inserted_at, :updated_at]}
  schema "users" do
    field :username, :string
    field :email, :string
    field :role, :string, default: "user"
    field :password, :string, virtual: true
    field :password_hash, :string
    many_to_many :teams, TimeManager.Teams.Team, join_through: "users_teams"

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :role, :password])
    |> validate_required([:username, :email, :role])
    |> validate_inclusion(:role, ["admin", "manager", "user"])
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(pass))
      _ ->
        changeset
    end
  end
end

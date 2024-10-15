defmodule TimeManager.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    belongs_to :role, TimeManager.Accounts.Role

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :role_id])
    |> validate_required([:username, :email])
    |> unique_constraint(:email)
    |> foreign_key_constraint(:role_id)
  end
end

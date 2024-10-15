defmodule TimeManager.Accounts.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :name, :string
    many_to_many :permissions, TimeManager.Accounts.Permission, join_through: "roles_permissions"
    has_many :users, TimeManager.Accounts.User

    timestamps()
  end

  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end

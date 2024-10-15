defmodule TimeManager.Accounts.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "permissions" do
    field :name, :string
    many_to_many :roles, TimeManager.Accounts.Role, join_through: "roles_permissions"

    timestamps()
  end

  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end

defmodule TimeManager.Accounts do
  @moduledoc """
  Le contexte Accounts.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.Accounts.User

  @doc """
  Renvoie la liste des utilisateurs.

  ## Exemples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users(email \\ nil, username \\ nil) do
    User
    |> filter_by_email(email)
    |> filter_by_username(username)
    |> Repo.all()
  end

  defp filter_by_email(query, nil), do: query
  defp filter_by_email(query, email), do: where(query, [u], u.email == ^email)

  defp filter_by_username(query, nil), do: query
  defp filter_by_username(query, username), do: where(query, [u], u.username == ^username)

  @doc """
  Obtient un seul utilisateur.

  Lève `Ecto.NoResultsError` si l'utilisateur n'existe pas.

  ## Exemples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Crée un utilisateur.

  ## Exemples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Met à jour un utilisateur.

  ## Exemples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Supprime un utilisateur.

  ## Exemples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Renvoie un `%Ecto.Changeset{}` pour suivre les changements de l'utilisateur.

  ## Exemples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  alias TimeManager.Accounts.Role

  @doc """
  Renvoie la liste des rôles.

  ## Exemples

      iex> list_roles()
      [%Role{}, ...]

  """
  def list_roles do
    Repo.all(Role)
  end

  @doc """
  Obtient un seul rôle.

  Lève `Ecto.NoResultsError` si le rôle n'existe pas.

  ## Exemples

      iex> get_role!(123)
      %Role{}

      iex> get_role!(456)
      ** (Ecto.NoResultsError)

  """
  def get_role!(id), do: Repo.get!(Role, id)

  @doc """
  Crée un rôle.

  ## Exemples

      iex> create_role(%{field: value})
      {:ok, %Role{}}

      iex> create_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Met à jour un rôle.

  ## Exemples

      iex> update_role(role, %{field: new_value})
      {:ok, %Role{}}

      iex> update_role(role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_role(%Role{} = role, attrs) do
    role
    |> Role.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Supprime un rôle.

  ## Exemples

      iex> delete_role(role)
      {:ok, %Role{}}

      iex> delete_role(role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_role(%Role{} = role) do
    Repo.delete(role)
  end

  @doc """
  Renvoie un `%Ecto.Changeset{}` pour suivre les changements du rôle.

  ## Exemples

      iex> change_role(role)
      %Ecto.Changeset{data: %Role{}}

  """
  def change_role(%Role{} = role, attrs \\ %{}) do
    Role.changeset(role, attrs)
  end

  alias TimeManager.Accounts.Permission

  @doc """
  Renvoie la liste des permissions.

  ## Exemples

      iex> list_permissions()
      [%Permission{}, ...]

  """
  def list_permissions do
    Repo.all(Permission)
  end

  @doc """
  Obtient une seule permission.

  Lève `Ecto.NoResultsError` si la permission n'existe pas.

  ## Exemples

      iex> get_permission!(123)
      %Permission{}

      iex> get_permission!(456)
      ** (Ecto.NoResultsError)

  """
  def get_permission!(id), do: Repo.get!(Permission, id)

  @doc """
  Crée une permission.

  ## Exemples

      iex> create_permission(%{field: value})
      {:ok, %Permission{}}

      iex> create_permission(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_permission(attrs \\ %{}) do
    %Permission{}
    |> Permission.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Met à jour une permission.

  ## Exemples

      iex> update_permission(permission, %{field: new_value})
      {:ok, %Permission{}}

      iex> update_permission(permission, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_permission(%Permission{} = permission, attrs) do
    permission
    |> Permission.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Supprime une permission.

  ## Exemples

      iex> delete_permission(permission)
      {:ok, %Permission{}}

      iex> delete_permission(permission)
      {:error, %Ecto.Changeset{}}

  """
  def delete_permission(%Permission{} = permission) do
    Repo.delete(permission)
  end

  @doc """
  Renvoie un `%Ecto.Changeset{}` pour suivre les changements de la permission.

  ## Exemples

      iex> change_permission(permission)
      %Ecto.Changeset{data: %Permission{}}

  """
  def change_permission(%Permission{} = permission, attrs \\ %{}) do
    Permission.changeset(permission, attrs)
  end

  def add_permission_to_role(role_id, permission_id) do
    role = get_role!(role_id)
    permission = get_permission!(permission_id)

    role
    |> Repo.preload(:permissions)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:permissions, [permission | role.permissions])
    |> Repo.update()
  end

  def remove_permission_from_role(role_id, permission_id) do
    role = get_role!(role_id)
    permission = get_permission!(permission_id)

    role
    |> Repo.preload(:permissions)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:permissions, Enum.filter(role.permissions, &(&1.id != permission.id)))
    |> Repo.update()
  end

  def user_has_permission?(user_id, permission_name) do
    user = get_user!(user_id) |> Repo.preload(role: :permissions)
    Enum.any?(user.role.permissions, &(&1.name == permission_name))
  end

  def update_user_role(user, new_role) do
    user
    |> User.changeset(%{role: new_role})
    |> Repo.update()
  end

  def promote_to_manager(user_id) do
    get_user!(user_id)
    |> update_user_role("manager")
  end

  def promote_to_admin(user_id) do
    get_user!(user_id)
    |> update_user_role("admin")
  end

  def demote_to_user(user_id) do
    get_user!(user_id)
    |> update_user_role("user")
  end
end

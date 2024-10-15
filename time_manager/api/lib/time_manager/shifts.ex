defmodule TimeManager.Shifts do
  @moduledoc """
  Le contexte des Shifts.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo
  alias TimeManager.Shifts.NightShift

  @doc """
  Renvoie la liste des night_shifts pour un utilisateur spécifique.

  ## Exemples

      iex> list_user_night_shifts(1)
      [%NightShift{}, ...]

  """
  def list_user_night_shifts(user_id) do
    NightShift
    |> where(user_id: ^user_id)
    |> Repo.all()
  end

  @doc """
  Renvoie la liste de tous les night_shifts.

  ## Exemples

      iex> list_night_shifts()
      [%NightShift{}, ...]

  """
  def list_night_shifts do
    Repo.all(NightShift)
  end

  @doc """
  Obtient un seul night_shift.

  Lève une `Ecto.NoResultsError` si le Night shift n'existe pas.

  ## Exemples

      iex> get_night_shift!(123)
      %NightShift{}

      iex> get_night_shift!(456)
      ** (Ecto.NoResultsError)

  """
  def get_night_shift!(id), do: Repo.get!(NightShift, id)

  @doc """
  Crée un night_shift.

  ## Exemples

      iex> create_night_shift(%{field: value})
      {:ok, %NightShift{}}

      iex> create_night_shift(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_night_shift(attrs \\ %{}) do
    %NightShift{}
    |> NightShift.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Met à jour un night_shift.

  ## Exemples

      iex> update_night_shift(night_shift, %{field: new_value})
      {:ok, %NightShift{}}

      iex> update_night_shift(night_shift, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_night_shift(%NightShift{} = night_shift, attrs) do
    night_shift
    |> NightShift.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Supprime un night_shift.

  ## Exemples

      iex> delete_night_shift(night_shift)
      {:ok, %NightShift{}}

      iex> delete_night_shift(night_shift)
      {:error, %Ecto.Changeset{}}

  """
  def delete_night_shift(%NightShift{} = night_shift) do
    Repo.delete(night_shift)
  end

  @doc """
  Renvoie un `%Ecto.Changeset{}` pour suivre les changements de night_shift.

  ## Exemples

      iex> change_night_shift(night_shift)
      %Ecto.Changeset{data: %NightShift{}}

  """
  def change_night_shift(%NightShift{} = night_shift, attrs \\ %{}) do
    NightShift.changeset(night_shift, attrs)
  end
end

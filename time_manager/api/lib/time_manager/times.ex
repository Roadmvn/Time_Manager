defmodule TimeManager.Times do
  @moduledoc """
  The Times context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.Times.Clock

  @doc """
  Returns the list of clocks.

  ## Examples

      iex> list_clocks()
      [%Clock{}, ...]

  """
  def list_clocks do
    Repo.all(Clock)
  end

  @doc """
  Gets a single clock.

  Raises `Ecto.NoResultsError` if the Clock does not exist.

  ## Examples

      iex> get_clock!(123)
      %Clock{}

      iex> get_clock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clock!(id), do: Repo.get!(Clock, id)

  @doc """
  Creates a clock.

  ## Examples

      iex> create_clock(%{field: value})
      {:ok, %Clock{}}

      iex> create_clock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_clock(attrs \\ %{}) do
    %Clock{}
    |> Clock.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a clock.

  ## Examples

      iex> update_clock(clock, %{field: new_value})
      {:ok, %Clock{}}

      iex> update_clock(clock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_clock(%Clock{} = clock, attrs) do
    clock
    |> Clock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a clock.

  ## Examples

      iex> delete_clock(clock)
      {:ok, %Clock{}}

      iex> delete_clock(clock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clock(%Clock{} = clock) do
    Repo.delete(clock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clock changes.

  ## Examples

      iex> change_clock(clock)
      %Ecto.Changeset{data: %Clock{}}

  """
  def change_clock(%Clock{} = clock, attrs \\ %{}) do
    Clock.changeset(clock, attrs)
  end

  alias TimeManager.Times.WorkingTime

  @doc """
  Returns the list of workingtimes.

  ## Examples

      iex> list_workingtimes()
      [%WorkingTime{}, ...]

  """
  def list_workingtimes do
    Repo.all(WorkingTime)
  end

  @doc """
  Gets a single working_time.

  Raises `Ecto.NoResultsError` if the Working time does not exist.

  ## Examples

      iex> get_working_time!(123)
      %WorkingTime{}

      iex> get_working_time!(456)
      ** (Ecto.NoResultsError)

  """
  def get_working_time!(id), do: Repo.get!(WorkingTime, id)

  @doc """
  Creates a working_time.

  ## Examples

      iex> create_working_time(%{field: value})
      {:ok, %WorkingTime{}}

      iex> create_working_time(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_working_time(user_id, attrs \\ %{}) do
    attrs = Map.put(attrs, "user_id", user_id)

    %WorkingTime{}
    |> WorkingTime.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a working_time.

  ## Examples

      iex> update_working_time(working_time, %{field: new_value})
      {:ok, %WorkingTime{}}

      iex> update_working_time(working_time, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_working_time(%WorkingTime{} = working_time, attrs) do
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a working_time.

  ## Examples

      iex> delete_working_time(working_time)
      {:ok, %WorkingTime{}}

      iex> delete_working_time(working_time)
      {:error, %Ecto.Changeset{}}

  """
  def delete_working_time(%WorkingTime{} = working_time) do
    Repo.delete(working_time)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking working_time changes.

  ## Examples

      iex> change_working_time(working_time)
      %Ecto.Changeset{data: %WorkingTime{}}

  """
  def change_working_time(%WorkingTime{} = working_time, attrs \\ %{}) do
    WorkingTime.changeset(working_time, attrs)
  end

  def list_clocks(user_id) do
    Clock
    |> where([c], c.user_id == ^user_id)
    |> Repo.all()
  end

  def list_workingtimes(user_id, start \\ nil, end_time \\ nil) do
    WorkingTime
    |> where([w], w.user_id == ^user_id)
    |> filter_by_date_range(start, end_time)
    |> Repo.all()
  end

  defp filter_by_date_range(query, nil, nil), do: query

  defp filter_by_date_range(query, start, nil) do
    query |> where([w], w.start >= ^start)
  end

  defp filter_by_date_range(query, nil, end_time) do
    query |> where([w], w.end <= ^end_time)
  end

  defp filter_by_date_range(query, start, end_time) do
    query |> where([w], w.start >= ^start and w.end <= ^end_time)
  end

  def get_working_time!(id, user_id) do
    WorkingTime
    |> where([w], w.id == ^id and w.user_id == ^user_id)
    |> Repo.one!()
  end

  def get_working_times_by_user!(user_id) do
    WorkingTime
    |> where([w], w.user_id == ^user_id)
    |> Repo.all()
  end

  alias TimeManager.Times.FlexibleWorkingTime

  @doc """
  Returns the list of flexible_working_times.

  ## Examples

      iex> list_flexible_working_times()
      [%FlexibleWorkingTime{}, ...]

  """
  def list_flexible_working_times do
    Repo.all(FlexibleWorkingTime)
  end

  @doc """
  Gets a single flexible_working_time.

  Raises `Ecto.NoResultsError` if the Flexible working time does not exist.

  ## Examples

      iex> get_flexible_working_time!(123)
      %FlexibleWorkingTime{}

      iex> get_flexible_working_time!(456)
      ** (Ecto.NoResultsError)

  """
  def get_flexible_working_time!(id), do: Repo.get!(FlexibleWorkingTime, id)

  @doc """
  Creates a flexible_working_time.

  ## Examples

      iex> create_flexible_working_time(%{field: value})
      {:ok, %FlexibleWorkingTime{}}

      iex> create_flexible_working_time(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_flexible_working_time(attrs \\ %{}) do
    %FlexibleWorkingTime{}
    |> FlexibleWorkingTime.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a flexible_working_time.

  ## Examples

      iex> update_flexible_working_time(flexible_working_time, %{field: new_value})
      {:ok, %FlexibleWorkingTime{}}

      iex> update_flexible_working_time(flexible_working_time, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_flexible_working_time(%FlexibleWorkingTime{} = flexible_working_time, attrs) do
    flexible_working_time
    |> FlexibleWorkingTime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a flexible_working_time.

  ## Examples

      iex> delete_flexible_working_time(flexible_working_time)
      {:ok, %FlexibleWorkingTime{}}

      iex> delete_flexible_working_time(flexible_working_time)
      {:error, %Ecto.Changeset{}}

  """
  def delete_flexible_working_time(%FlexibleWorkingTime{} = flexible_working_time) do
    Repo.delete(flexible_working_time)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking flexible_working_time changes.

  ## Examples

      iex> change_flexible_working_time(flexible_working_time)
      %Ecto.Changeset{data: %FlexibleWorkingTime{}}

  """
  def change_flexible_working_time(%FlexibleWorkingTime{} = flexible_working_time, attrs \\ %{}) do
    FlexibleWorkingTime.changeset(flexible_working_time, attrs)
  end

  def create_team_working_time(team_id, start_time, end_time) do
    team = Teams.get_team!(team_id)

    Enum.each(team.users, fn user ->
      create_working_time(%{
        user_id: user.id,
        start: start_time,
        end: end_time,
        is_team_time: true
      })
    end)
  end
end

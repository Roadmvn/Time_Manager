defmodule TimeManager.TimesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Times` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~N[2024-10-07 09:14:00]
      })
      |> TimeManager.Times.create_clock()

    clock
  end

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~N[2024-10-07 09:19:00]
      })
      |> TimeManager.Times.create_clock()

    clock
  end

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~N[2024-10-07 09:19:00],
        start: ~N[2024-10-07 09:19:00]
      })
      |> TimeManager.Times.create_working_time()

    working_time
  end

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~N[2024-10-07 09:24:00]
      })
      |> TimeManager.Times.create_clock()

    clock
  end

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~N[2024-10-07 09:24:00],
        start: ~N[2024-10-07 09:24:00]
      })
      |> TimeManager.Times.create_working_time()

    working_time
  end
end

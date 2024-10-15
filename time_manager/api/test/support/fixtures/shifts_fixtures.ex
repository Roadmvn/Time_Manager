defmodule TimeManager.ShiftsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Shifts` context.
  """

  @doc """
  Generate a night_shift.
  """
  def night_shift_fixture(attrs \\ %{}) do
    {:ok, night_shift} =
      attrs
      |> Enum.into(%{
        consecutive_nights: 42,
        shift_date: ~D[2024-10-14]
      })
      |> TimeManager.Shifts.create_night_shift()

    night_shift
  end
end

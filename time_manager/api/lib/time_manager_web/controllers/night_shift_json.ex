defmodule TimeManagerWeb.NightShiftJSON do
  alias TimeManager.Shifts.NightShift

  @doc """
  Renders a list of night_shifts.
  """
  def index(%{night_shifts: night_shifts}) do
    %{data: for(night_shift <- night_shifts, do: data(night_shift))}
  end

  @doc """
  Renders a single night_shift.
  """
  def show(%{night_shift: night_shift}) do
    %{data: data(night_shift)}
  end

  defp data(%NightShift{} = night_shift) do
    %{
      id: night_shift.id,
      shift_date: night_shift.shift_date,
      consecutive_nights: night_shift.consecutive_nights
    }
  end
end

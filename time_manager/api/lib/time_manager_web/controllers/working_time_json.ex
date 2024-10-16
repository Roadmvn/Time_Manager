defmodule TimeManagerWeb.WorkingTimeJSON do
  alias TimeManager.Times.WorkingTime

  @doc """
  Renders a list of workingtimes.
  """
  def index(%{workingtimes: workingtimes}) do
    %{data: for(working_time <- workingtimes, do: data(working_time))}
  end

  @doc """
  Renders a single working_time.
  """
  def show(%{working_time: working_time}) do
    %{data: data(working_time)}
  end

  defp data(%WorkingTime{} = working_time) do
    %{
      id: working_time.id,
      start: working_time.start,
      end: working_time.end,
      night_hours: working_time.night_hours,
      day_hours: working_time.day_hours,
      overtime_hours: working_time.overtime_hours
    }
  end
end

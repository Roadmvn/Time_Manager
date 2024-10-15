defmodule TimeManagerWeb.FlexibleWorkingTimeJSON do
  alias TimeManager.Times.FlexibleWorkingTime

  @doc """
  Renders a list of flexible_working_times.
  """
  def index(%{flexible_working_times: flexible_working_times}) do
    %{data: for(flexible_working_time <- flexible_working_times, do: data(flexible_working_time))}
  end

  @doc """
  Renders a single flexible_working_time.
  """
  def show(%{flexible_working_time: flexible_working_time}) do
    %{data: data(flexible_working_time)}
  end

  defp data(%FlexibleWorkingTime{} = flexible_working_time) do
    %{
      id: flexible_working_time.id,
      start_time: flexible_working_time.start_time,
      end_time: flexible_working_time.end_time,
      night_hours: flexible_working_time.night_hours,
      overtime_hours: flexible_working_time.overtime_hours
    }
  end
end

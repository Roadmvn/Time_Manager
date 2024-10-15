defmodule TimeManagerWeb.FlexibleWorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.Times
  alias TimeManager.Times.FlexibleWorkingTime

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    flexible_working_times = Times.list_flexible_working_times()
    render(conn, :index, flexible_working_times: flexible_working_times)
  end

  def create(conn, %{"flexible_working_time" => flexible_working_time_params}) do
    with {:ok, %FlexibleWorkingTime{} = flexible_working_time} <- Times.create_flexible_working_time(flexible_working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/flexible_working_times/#{flexible_working_time}")
      |> render(:show, flexible_working_time: flexible_working_time)
    end
  end

  def show(conn, %{"id" => id}) do
    flexible_working_time = Times.get_flexible_working_time!(id)
    render(conn, :show, flexible_working_time: flexible_working_time)
  end

  def update(conn, %{"id" => id, "flexible_working_time" => flexible_working_time_params}) do
    flexible_working_time = Times.get_flexible_working_time!(id)

    with {:ok, %FlexibleWorkingTime{} = flexible_working_time} <- Times.update_flexible_working_time(flexible_working_time, flexible_working_time_params) do
      render(conn, :show, flexible_working_time: flexible_working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    flexible_working_time = Times.get_flexible_working_time!(id)

    with {:ok, %FlexibleWorkingTime{}} <- Times.delete_flexible_working_time(flexible_working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end

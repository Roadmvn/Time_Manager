defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.Times
  alias TimeManager.Times.WorkingTime

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, %{"user_id" => user_id, "start" => start, "end" => end_time}) do
    workingtimes = Times.list_workingtimes(user_id, start, end_time)
    render(conn, :index, workingtimes: workingtimes)
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    working_time = Times.get_working_time!(id, user_id)
    render(conn, :show, working_time: working_time)
  end

  def create(conn, %{"user_id" => user_id, "working_time" => working_time_params}) do
    with {:ok, %WorkingTime{} = working_time} <- Times.create_working_time(user_id, working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtime/#{user_id}/#{working_time.id}")
      |> render(:show, working_time: working_time)
    end
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Times.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- Times.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = Times.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Times.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end

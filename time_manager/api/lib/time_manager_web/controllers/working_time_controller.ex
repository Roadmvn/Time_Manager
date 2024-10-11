defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.Times
  alias TimeManager.Times.WorkingTime

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    workingtimes = Times.list_workingtimes()
    render(conn, :index, workingtimes: workingtimes)
  end

  def create(conn, %{"working_time" => working_time_params}) do
    user_id = working_time_params["user_id"]
    with {:ok, %WorkingTime{} = working_time} <- Times.create_working_time(user_id, working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtime/#{working_time.user_id}/#{working_time.id}")
      |> render(:show, working_time: working_time)
    end
  end

  def show(conn, %{"user_id" => user_id}) do
    working_times = Times.get_working_times_by_user!(user_id)
    render(conn, :index, workingtimes: working_times)
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

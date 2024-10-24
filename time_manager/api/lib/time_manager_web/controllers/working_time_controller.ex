defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.Times
  alias TimeManager.Times.WorkingTime

  action_fallback(TimeManagerWeb.FallbackController)

  # GET /api/workingtime
  def index(conn, _params) do
    IO.inspect("BONJOUUUUUUUUr")
    workingtimes = Times.list_workingtimes()
    render(conn, :index, workingtimes: workingtimes)
  end

  # POST /api/workingtime
  def create(conn, %{"working_time" => working_time_params}) do
    user_id = working_time_params["user_id"]

    with {:ok, %WorkingTime{} = working_time} <-
           Times.create_working_time(user_id, working_time_params) do
            IO.inspect(working_time, label: "working_time")

      conn
      |> put_status(:created)
      |> render(:show, working_time: working_time)
    end
  end

  # GET /api/workingtime/:user_id
  def show(conn, %{"id" => user_id}) do
    IO.inspect("HELLLLOW")
    working_times = Times.get_working_times_by_user!(user_id)
    render(conn, :index, workingtimes: working_times)
  end

  # PUT /api/workingtime/:id
  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Times.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <-
           Times.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  # DELETE /api/workingtime/:id
  def delete(conn, %{"id" => id}) do
    working_time = Times.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Times.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end

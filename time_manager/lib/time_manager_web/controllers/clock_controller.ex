defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  alias TimeManager.Times
  alias TimeManager.Times.Clock

  def index(conn, %{"user_id" => user_id}) do
    clocks = Times.list_clocks(user_id)
    render(conn, :index, clocks: clocks)
  end

  def create(conn, %{"user_id" => user_id, "clock" => clock_params}) do
    with {:ok, %Clock{} = clock} <- Times.create_clock(user_id, clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{user_id}")
      |> render(:show, clock: clock)
    end
  end

  def show(conn, %{"id" => id}) do
    clock = Times.get_clock!(id)
    render(conn, :show, clock: clock)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Times.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Times.update_clock(clock, clock_params) do
      render(conn, :show, clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Times.get_clock!(id)

    with {:ok, %Clock{}} <- Times.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end

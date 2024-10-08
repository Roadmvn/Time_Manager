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
end

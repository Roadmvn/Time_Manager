defmodule TimeManagerWeb.NightShiftController do
  use TimeManagerWeb, :controller

  alias TimeManager.Shifts
  alias TimeManager.Shifts.NightShift

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, %{"user_id" => user_id}) do
    night_shifts = Shifts.list_user_night_shifts(user_id)
    render(conn, :index, night_shifts: night_shifts)
  end

  def create(conn, %{"night_shift" => night_shift_params}) do
    with {:ok, %NightShift{} = night_shift} <- Shifts.create_night_shift(night_shift_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/night_shifts/#{night_shift}")
      |> render(:show, night_shift: night_shift)
    end
  end

  def show(conn, %{"id" => id}) do
    night_shift = Shifts.get_night_shift!(id)
    render(conn, :show, night_shift: night_shift)
  end

  def update(conn, %{"id" => id, "night_shift" => night_shift_params}) do
    night_shift = Shifts.get_night_shift!(id)

    with {:ok, %NightShift{} = night_shift} <- Shifts.update_night_shift(night_shift, night_shift_params) do
      render(conn, :show, night_shift: night_shift)
    end
  end

  def delete(conn, %{"id" => id}) do
    night_shift = Shifts.get_night_shift!(id)

    with {:ok, %NightShift{}} <- Shifts.delete_night_shift(night_shift) do
      send_resp(conn, :no_content, "")
    end
  end
end

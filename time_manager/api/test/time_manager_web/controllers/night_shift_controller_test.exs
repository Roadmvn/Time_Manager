defmodule TimeManagerWeb.NightShiftControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.ShiftsFixtures

  alias TimeManager.Shifts.NightShift

  @create_attrs %{
    consecutive_nights: 42,
    shift_date: ~D[2024-10-14]
  }
  @update_attrs %{
    consecutive_nights: 43,
    shift_date: ~D[2024-10-15]
  }
  @invalid_attrs %{consecutive_nights: nil, shift_date: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all night_shifts", %{conn: conn} do
      conn = get(conn, ~p"/api/night_shifts")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create night_shift" do
    test "renders night_shift when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/night_shifts", night_shift: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/night_shifts/#{id}")

      assert %{
               "id" => ^id,
               "consecutive_nights" => 42,
               "shift_date" => "2024-10-14"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/night_shifts", night_shift: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update night_shift" do
    setup [:create_night_shift]

    test "renders night_shift when data is valid", %{conn: conn, night_shift: %NightShift{id: id} = night_shift} do
      conn = put(conn, ~p"/api/night_shifts/#{night_shift}", night_shift: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/night_shifts/#{id}")

      assert %{
               "id" => ^id,
               "consecutive_nights" => 43,
               "shift_date" => "2024-10-15"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, night_shift: night_shift} do
      conn = put(conn, ~p"/api/night_shifts/#{night_shift}", night_shift: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete night_shift" do
    setup [:create_night_shift]

    test "deletes chosen night_shift", %{conn: conn, night_shift: night_shift} do
      conn = delete(conn, ~p"/api/night_shifts/#{night_shift}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/night_shifts/#{night_shift}")
      end
    end
  end

  defp create_night_shift(_) do
    night_shift = night_shift_fixture()
    %{night_shift: night_shift}
  end
end

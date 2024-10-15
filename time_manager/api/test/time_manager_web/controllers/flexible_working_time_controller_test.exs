defmodule TimeManagerWeb.FlexibleWorkingTimeControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.TimesFixtures

  alias TimeManager.Times.FlexibleWorkingTime

  @create_attrs %{
    end_time: ~U[2024-10-14 20:12:00Z],
    night_hours: 120.5,
    overtime_hours: 120.5,
    start_time: ~U[2024-10-14 20:12:00Z]
  }
  @update_attrs %{
    end_time: ~U[2024-10-15 20:12:00Z],
    night_hours: 456.7,
    overtime_hours: 456.7,
    start_time: ~U[2024-10-15 20:12:00Z]
  }
  @invalid_attrs %{end_time: nil, night_hours: nil, overtime_hours: nil, start_time: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all flexible_working_times", %{conn: conn} do
      conn = get(conn, ~p"/api/flexible_working_times")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create flexible_working_time" do
    test "renders flexible_working_time when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/flexible_working_times", flexible_working_time: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/flexible_working_times/#{id}")

      assert %{
               "id" => ^id,
               "end_time" => "2024-10-14T20:12:00Z",
               "night_hours" => 120.5,
               "overtime_hours" => 120.5,
               "start_time" => "2024-10-14T20:12:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/flexible_working_times", flexible_working_time: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update flexible_working_time" do
    setup [:create_flexible_working_time]

    test "renders flexible_working_time when data is valid", %{conn: conn, flexible_working_time: %FlexibleWorkingTime{id: id} = flexible_working_time} do
      conn = put(conn, ~p"/api/flexible_working_times/#{flexible_working_time}", flexible_working_time: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/flexible_working_times/#{id}")

      assert %{
               "id" => ^id,
               "end_time" => "2024-10-15T20:12:00Z",
               "night_hours" => 456.7,
               "overtime_hours" => 456.7,
               "start_time" => "2024-10-15T20:12:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, flexible_working_time: flexible_working_time} do
      conn = put(conn, ~p"/api/flexible_working_times/#{flexible_working_time}", flexible_working_time: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete flexible_working_time" do
    setup [:create_flexible_working_time]

    test "deletes chosen flexible_working_time", %{conn: conn, flexible_working_time: flexible_working_time} do
      conn = delete(conn, ~p"/api/flexible_working_times/#{flexible_working_time}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/flexible_working_times/#{flexible_working_time}")
      end
    end
  end

  defp create_flexible_working_time(_) do
    flexible_working_time = flexible_working_time_fixture()
    %{flexible_working_time: flexible_working_time}
  end
end

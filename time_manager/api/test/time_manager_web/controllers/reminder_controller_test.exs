defmodule TimeManagerWeb.ReminderControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.NotificationsFixtures

  alias TimeManager.Notifications.Reminder

  @create_attrs %{
    message: "some message",
    sent_at: ~U[2024-10-14 20:21:00Z]
  }
  @update_attrs %{
    message: "some updated message",
    sent_at: ~U[2024-10-15 20:21:00Z]
  }
  @invalid_attrs %{message: nil, sent_at: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all reminders", %{conn: conn} do
      conn = get(conn, ~p"/api/reminders")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create reminder" do
    test "renders reminder when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/reminders", reminder: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/reminders/#{id}")

      assert %{
               "id" => ^id,
               "message" => "some message",
               "sent_at" => "2024-10-14T20:21:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/reminders", reminder: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update reminder" do
    setup [:create_reminder]

    test "renders reminder when data is valid", %{conn: conn, reminder: %Reminder{id: id} = reminder} do
      conn = put(conn, ~p"/api/reminders/#{reminder}", reminder: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/reminders/#{id}")

      assert %{
               "id" => ^id,
               "message" => "some updated message",
               "sent_at" => "2024-10-15T20:21:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, reminder: reminder} do
      conn = put(conn, ~p"/api/reminders/#{reminder}", reminder: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete reminder" do
    setup [:create_reminder]

    test "deletes chosen reminder", %{conn: conn, reminder: reminder} do
      conn = delete(conn, ~p"/api/reminders/#{reminder}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/reminders/#{reminder}")
      end
    end
  end

  defp create_reminder(_) do
    reminder = reminder_fixture()
    %{reminder: reminder}
  end
end

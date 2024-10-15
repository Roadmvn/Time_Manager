defmodule TimeManagerWeb.ReminderController do
  use TimeManagerWeb, :controller

  alias TimeManager.Notifications
  alias TimeManager.Notifications.Reminder

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    reminders = Notifications.list_reminders()
    render(conn, :index, reminders: reminders)
  end

  def create(conn, %{"reminder" => reminder_params}) do
    with {:ok, %Reminder{} = reminder} <- Notifications.create_reminder(reminder_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/reminders/#{reminder}")
      |> render(:show, reminder: reminder)
    end
  end

  def show(conn, %{"id" => id}) do
    reminder = Notifications.get_reminder!(id)
    render(conn, :show, reminder: reminder)
  end

  def update(conn, %{"id" => id, "reminder" => reminder_params}) do
    reminder = Notifications.get_reminder!(id)

    with {:ok, %Reminder{} = reminder} <- Notifications.update_reminder(reminder, reminder_params) do
      render(conn, :show, reminder: reminder)
    end
  end

  def delete(conn, %{"id" => id}) do
    reminder = Notifications.get_reminder!(id)

    with {:ok, %Reminder{}} <- Notifications.delete_reminder(reminder) do
      send_resp(conn, :no_content, "")
    end
  end
end

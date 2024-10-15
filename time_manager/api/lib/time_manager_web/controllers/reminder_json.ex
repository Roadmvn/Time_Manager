defmodule TimeManagerWeb.ReminderJSON do
  alias TimeManager.Notifications.Reminder

  @doc """
  Renders a list of reminders.
  """
  def index(%{reminders: reminders}) do
    %{data: for(reminder <- reminders, do: data(reminder))}
  end

  @doc """
  Renders a single reminder.
  """
  def show(%{reminder: reminder}) do
    %{data: data(reminder)}
  end

  defp data(%Reminder{} = reminder) do
    %{
      id: reminder.id,
      message: reminder.message,
      sent_at: reminder.sent_at
    }
  end
end

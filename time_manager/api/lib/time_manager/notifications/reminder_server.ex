defmodule TimeManager.Notifications.ReminderServer do
  use GenServer
  alias TimeManager.Notifications
  alias TimeManager.Accounts

  # Client API

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def check_inactivity() do
    GenServer.cast(__MODULE__, :check_inactivity)
  end

  # Server Callbacks

  def init(state) do
    schedule_check()
    {:ok, state}
  end

  def handle_cast(:check_inactivity, state) do
    check_and_send_reminders()
    schedule_check()
    {:noreply, state}
  end

  defp schedule_check do
    Process.send_after(self(), :check_inactivity, :timer.minutes(15))
  end

  defp check_and_send_reminders do
    Accounts.list_users()
    |> Enum.each(fn user ->
      case Notifications.user_needs_reminder?(user) do
        true ->
          Notifications.create_reminder(%{
            message: "N'oubliez pas de pointer !",
            user_id: user.id,
            sent_at: DateTime.utc_now()
          })
        false ->
          :ok
      end
    end)
  end
end

defmodule TimeManager.NotificationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Notifications` context.
  """

  @doc """
  Generate a reminder.
  """
  def reminder_fixture(attrs \\ %{}) do
    {:ok, reminder} =
      attrs
      |> Enum.into(%{
        message: "some message",
        sent_at: ~U[2024-10-14 20:21:00Z]
      })
      |> TimeManager.Notifications.create_reminder()

    reminder
  end
end

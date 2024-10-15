defmodule TimeManager.NotificationsTest do
  use TimeManager.DataCase

  alias TimeManager.Notifications

  describe "reminders" do
    alias TimeManager.Notifications.Reminder

    import TimeManager.NotificationsFixtures

    @invalid_attrs %{message: nil, sent_at: nil}

    test "list_reminders/0 returns all reminders" do
      reminder = reminder_fixture()
      assert Notifications.list_reminders() == [reminder]
    end

    test "get_reminder!/1 returns the reminder with given id" do
      reminder = reminder_fixture()
      assert Notifications.get_reminder!(reminder.id) == reminder
    end

    test "create_reminder/1 with valid data creates a reminder" do
      valid_attrs = %{message: "some message", sent_at: ~U[2024-10-14 20:21:00Z]}

      assert {:ok, %Reminder{} = reminder} = Notifications.create_reminder(valid_attrs)
      assert reminder.message == "some message"
      assert reminder.sent_at == ~U[2024-10-14 20:21:00Z]
    end

    test "create_reminder/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notifications.create_reminder(@invalid_attrs)
    end

    test "update_reminder/2 with valid data updates the reminder" do
      reminder = reminder_fixture()
      update_attrs = %{message: "some updated message", sent_at: ~U[2024-10-15 20:21:00Z]}

      assert {:ok, %Reminder{} = reminder} = Notifications.update_reminder(reminder, update_attrs)
      assert reminder.message == "some updated message"
      assert reminder.sent_at == ~U[2024-10-15 20:21:00Z]
    end

    test "update_reminder/2 with invalid data returns error changeset" do
      reminder = reminder_fixture()
      assert {:error, %Ecto.Changeset{}} = Notifications.update_reminder(reminder, @invalid_attrs)
      assert reminder == Notifications.get_reminder!(reminder.id)
    end

    test "delete_reminder/1 deletes the reminder" do
      reminder = reminder_fixture()
      assert {:ok, %Reminder{}} = Notifications.delete_reminder(reminder)
      assert_raise Ecto.NoResultsError, fn -> Notifications.get_reminder!(reminder.id) end
    end

    test "change_reminder/1 returns a reminder changeset" do
      reminder = reminder_fixture()
      assert %Ecto.Changeset{} = Notifications.change_reminder(reminder)
    end
  end
end

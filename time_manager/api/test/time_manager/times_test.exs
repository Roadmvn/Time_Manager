defmodule TimeManager.TimesTest do
  use TimeManager.DataCase

  alias TimeManager.Times

  describe "clocks" do
    alias TimeManager.Times.Clock

    import TimeManager.TimesFixtures

    @invalid_attrs %{status: nil, time: nil}

    test "list_clocks/0 returns all clocks" do
      clock = clock_fixture()
      assert Times.list_clocks() == [clock]
    end

    test "get_clock!/1 returns the clock with given id" do
      clock = clock_fixture()
      assert Times.get_clock!(clock.id) == clock
    end

    test "create_clock/1 with valid data creates a clock" do
      valid_attrs = %{status: true, time: ~N[2024-10-07 14:05:00]}

      assert {:ok, %Clock{} = clock} = Times.create_clock(valid_attrs)
      assert clock.status == true
      assert clock.time == ~N[2024-10-07 14:05:00]
    end

    test "create_clock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Times.create_clock(@invalid_attrs)
    end

    test "update_clock/2 with valid data updates the clock" do
      clock = clock_fixture()
      update_attrs = %{status: false, time: ~N[2024-10-08 14:05:00]}

      assert {:ok, %Clock{} = clock} = Times.update_clock(clock, update_attrs)
      assert clock.status == false
      assert clock.time == ~N[2024-10-08 14:05:00]
    end

    test "update_clock/2 with invalid data returns error changeset" do
      clock = clock_fixture()
      assert {:error, %Ecto.Changeset{}} = Times.update_clock(clock, @invalid_attrs)
      assert clock == Times.get_clock!(clock.id)
    end

    test "delete_clock/1 deletes the clock" do
      clock = clock_fixture()
      assert {:ok, %Clock{}} = Times.delete_clock(clock)
      assert_raise Ecto.NoResultsError, fn -> Times.get_clock!(clock.id) end
    end

    test "change_clock/1 returns a clock changeset" do
      clock = clock_fixture()
      assert %Ecto.Changeset{} = Times.change_clock(clock)
    end
  end

  describe "workingtimes" do
    alias TimeManager.Times.WorkingTime

    import TimeManager.TimesFixtures

    @invalid_attrs %{end: nil, start: nil}

    test "list_workingtimes/0 returns all workingtimes" do
      working_time = working_time_fixture()
      assert Times.list_workingtimes() == [working_time]
    end

    test "get_working_time!/1 returns the working_time with given id" do
      working_time = working_time_fixture()
      assert Times.get_working_time!(working_time.id) == working_time
    end

    test "create_working_time/1 with valid data creates a working_time" do
      valid_attrs = %{end: ~N[2024-10-07 14:05:00], start: ~N[2024-10-07 14:05:00]}

      assert {:ok, %WorkingTime{} = working_time} = Times.create_working_time(valid_attrs)
      assert working_time.end == ~N[2024-10-07 14:05:00]
      assert working_time.start == ~N[2024-10-07 14:05:00]
    end

    test "create_working_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Times.create_working_time(@invalid_attrs)
    end

    test "update_working_time/2 with valid data updates the working_time" do
      working_time = working_time_fixture()
      update_attrs = %{end: ~N[2024-10-08 14:05:00], start: ~N[2024-10-08 14:05:00]}

      assert {:ok, %WorkingTime{} = working_time} = Times.update_working_time(working_time, update_attrs)
      assert working_time.end == ~N[2024-10-08 14:05:00]
      assert working_time.start == ~N[2024-10-08 14:05:00]
    end

    test "update_working_time/2 with invalid data returns error changeset" do
      working_time = working_time_fixture()
      assert {:error, %Ecto.Changeset{}} = Times.update_working_time(working_time, @invalid_attrs)
      assert working_time == Times.get_working_time!(working_time.id)
    end

    test "delete_working_time/1 deletes the working_time" do
      working_time = working_time_fixture()
      assert {:ok, %WorkingTime{}} = Times.delete_working_time(working_time)
      assert_raise Ecto.NoResultsError, fn -> Times.get_working_time!(working_time.id) end
    end

    test "change_working_time/1 returns a working_time changeset" do
      working_time = working_time_fixture()
      assert %Ecto.Changeset{} = Times.change_working_time(working_time)
    end
  end

  describe "flexible_working_times" do
    alias TimeManager.Times.FlexibleWorkingTime

    import TimeManager.TimesFixtures

    @invalid_attrs %{end_time: nil, night_hours: nil, overtime_hours: nil, start_time: nil}

    test "list_flexible_working_times/0 returns all flexible_working_times" do
      flexible_working_time = flexible_working_time_fixture()
      assert Times.list_flexible_working_times() == [flexible_working_time]
    end

    test "get_flexible_working_time!/1 returns the flexible_working_time with given id" do
      flexible_working_time = flexible_working_time_fixture()
      assert Times.get_flexible_working_time!(flexible_working_time.id) == flexible_working_time
    end

    test "create_flexible_working_time/1 with valid data creates a flexible_working_time" do
      valid_attrs = %{end_time: ~U[2024-10-14 20:12:00Z], night_hours: 120.5, overtime_hours: 120.5, start_time: ~U[2024-10-14 20:12:00Z]}

      assert {:ok, %FlexibleWorkingTime{} = flexible_working_time} = Times.create_flexible_working_time(valid_attrs)
      assert flexible_working_time.end_time == ~U[2024-10-14 20:12:00Z]
      assert flexible_working_time.night_hours == 120.5
      assert flexible_working_time.overtime_hours == 120.5
      assert flexible_working_time.start_time == ~U[2024-10-14 20:12:00Z]
    end

    test "create_flexible_working_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Times.create_flexible_working_time(@invalid_attrs)
    end

    test "update_flexible_working_time/2 with valid data updates the flexible_working_time" do
      flexible_working_time = flexible_working_time_fixture()
      update_attrs = %{end_time: ~U[2024-10-15 20:12:00Z], night_hours: 456.7, overtime_hours: 456.7, start_time: ~U[2024-10-15 20:12:00Z]}

      assert {:ok, %FlexibleWorkingTime{} = flexible_working_time} = Times.update_flexible_working_time(flexible_working_time, update_attrs)
      assert flexible_working_time.end_time == ~U[2024-10-15 20:12:00Z]
      assert flexible_working_time.night_hours == 456.7
      assert flexible_working_time.overtime_hours == 456.7
      assert flexible_working_time.start_time == ~U[2024-10-15 20:12:00Z]
    end

    test "update_flexible_working_time/2 with invalid data returns error changeset" do
      flexible_working_time = flexible_working_time_fixture()
      assert {:error, %Ecto.Changeset{}} = Times.update_flexible_working_time(flexible_working_time, @invalid_attrs)
      assert flexible_working_time == Times.get_flexible_working_time!(flexible_working_time.id)
    end

    test "delete_flexible_working_time/1 deletes the flexible_working_time" do
      flexible_working_time = flexible_working_time_fixture()
      assert {:ok, %FlexibleWorkingTime{}} = Times.delete_flexible_working_time(flexible_working_time)
      assert_raise Ecto.NoResultsError, fn -> Times.get_flexible_working_time!(flexible_working_time.id) end
    end

    test "change_flexible_working_time/1 returns a flexible_working_time changeset" do
      flexible_working_time = flexible_working_time_fixture()
      assert %Ecto.Changeset{} = Times.change_flexible_working_time(flexible_working_time)
    end
  end
end

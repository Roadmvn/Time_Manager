defmodule TimeManager.ShiftsTest do
  use TimeManager.DataCase

  alias TimeManager.Shifts

  describe "night_shifts" do
    alias TimeManager.Shifts.NightShift

    import TimeManager.ShiftsFixtures

    @invalid_attrs %{consecutive_nights: nil, shift_date: nil}

    test "list_night_shifts/0 returns all night_shifts" do
      night_shift = night_shift_fixture()
      assert Shifts.list_night_shifts() == [night_shift]
    end

    test "get_night_shift!/1 returns the night_shift with given id" do
      night_shift = night_shift_fixture()
      assert Shifts.get_night_shift!(night_shift.id) == night_shift
    end

    test "create_night_shift/1 with valid data creates a night_shift" do
      valid_attrs = %{consecutive_nights: 42, shift_date: ~D[2024-10-14]}

      assert {:ok, %NightShift{} = night_shift} = Shifts.create_night_shift(valid_attrs)
      assert night_shift.consecutive_nights == 42
      assert night_shift.shift_date == ~D[2024-10-14]
    end

    test "create_night_shift/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shifts.create_night_shift(@invalid_attrs)
    end

    test "update_night_shift/2 with valid data updates the night_shift" do
      night_shift = night_shift_fixture()
      update_attrs = %{consecutive_nights: 43, shift_date: ~D[2024-10-15]}

      assert {:ok, %NightShift{} = night_shift} = Shifts.update_night_shift(night_shift, update_attrs)
      assert night_shift.consecutive_nights == 43
      assert night_shift.shift_date == ~D[2024-10-15]
    end

    test "update_night_shift/2 with invalid data returns error changeset" do
      night_shift = night_shift_fixture()
      assert {:error, %Ecto.Changeset{}} = Shifts.update_night_shift(night_shift, @invalid_attrs)
      assert night_shift == Shifts.get_night_shift!(night_shift.id)
    end

    test "delete_night_shift/1 deletes the night_shift" do
      night_shift = night_shift_fixture()
      assert {:ok, %NightShift{}} = Shifts.delete_night_shift(night_shift)
      assert_raise Ecto.NoResultsError, fn -> Shifts.get_night_shift!(night_shift.id) end
    end

    test "change_night_shift/1 returns a night_shift changeset" do
      night_shift = night_shift_fixture()
      assert %Ecto.Changeset{} = Shifts.change_night_shift(night_shift)
    end
  end
end

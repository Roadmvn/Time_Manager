defmodule TimeManager.Shifts.NightShift do
  use Ecto.Schema
  import Ecto.Changeset

  schema "night_shifts" do
    field :shift_date, :date
    field :consecutive_nights, :integer
    belongs_to :user, TimeManager.Accounts.User

    timestamps()
  end

  def changeset(night_shift, attrs) do
    night_shift
    |> cast(attrs, [:user_id, :shift_date, :consecutive_nights])
    |> validate_required([:user_id, :shift_date, :consecutive_nights])
    |> foreign_key_constraint(:user_id)
    |> validate_number(:consecutive_nights, less_than_or_equal_to: 3)
  end
end

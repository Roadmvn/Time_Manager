defmodule TimeManager.Times.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "working_times" do
    field :start, :utc_datetime
    field :end, :utc_datetime
    field :user_id, :integer
    field :night_hours, :float, default: 0.0
    field :day_hours, :float, default: 0.0
    field :overtime_hours, :float, default: 0.0

    timestamps()
  end

  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:start, :end, :user_id, :night_hours, :day_hours, :overtime_hours])
    |> validate_required([:start, :end, :user_id])
  end
end

defmodule TimeManager.Times.FlexibleWorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "flexible_working_times" do
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime
    field :night_hours, :float
    field :overtime_hours, :float
    belongs_to :user, TimeManager.Accounts.User

    timestamps()
  end

  def changeset(flexible_working_time, attrs) do
    flexible_working_time
    |> cast(attrs, [:start_time, :end_time, :night_hours, :overtime_hours, :user_id])
    |> validate_required([:start_time, :end_time, :user_id])
    |> foreign_key_constraint(:user_id)
    |> calculate_hours()
  end

  defp calculate_hours(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{start_time: start_time, end_time: end_time}} ->
        total_hours = DateTime.diff(end_time, start_time) / 3600
        night_hours = calculate_night_hours(start_time, end_time)
        overtime_hours = max(total_hours - 8, 0)  # Assuming 8 hours is a standard workday

        changeset
        |> put_change(:night_hours, night_hours)
        |> put_change(:overtime_hours, overtime_hours)

      _ ->
        changeset
    end
  end

  defp calculate_night_hours(start_time, end_time) do
    # Logic to calculate night hours (e.g., hours between 22:00 and 06:00)
    # This is a simplified example and might need to be adjusted based on your specific requirements
    night_start = Time.new!(22, 0, 0)
    night_end = Time.new!(6, 0, 0)

    Enum.reduce(DateTime.to_date(start_time)..DateTime.to_date(end_time), 0, fn date, acc ->
      date_start = max(DateTime.new!(date, night_start), start_time)
      date_end = min(DateTime.new!(Date.add(date, 1), night_end), end_time)

      if DateTime.compare(date_start, date_end) == :lt do
        acc + (DateTime.diff(date_end, date_start) / 3600)
      else
        acc
      end
    end)
  end
end

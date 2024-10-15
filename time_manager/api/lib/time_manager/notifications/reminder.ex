defmodule TimeManager.Notifications.Reminder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reminders" do
    field :message, :string
    field :sent_at, :utc_datetime
    belongs_to :user, TimeManager.Accounts.User

    timestamps()
  end

  def changeset(reminder, attrs) do
    reminder
    |> cast(attrs, [:message, :user_id, :sent_at])
    |> validate_required([:message, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end

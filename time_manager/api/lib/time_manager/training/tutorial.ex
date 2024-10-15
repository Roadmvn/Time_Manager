defmodule TimeManager.Training.Tutorial do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tutorials" do
    field :content, :string
    field :title, :string
    field :video_url, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tutorial, attrs) do
    tutorial
    |> cast(attrs, [:title, :content, :video_url])
    |> validate_required([:title, :content, :video_url])
  end
end

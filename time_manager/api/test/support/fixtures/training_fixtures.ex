defmodule TimeManager.TrainingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Training` context.
  """

  @doc """
  Generate a tutorial.
  """
  def tutorial_fixture(attrs \\ %{}) do
    {:ok, tutorial} =
      attrs
      |> Enum.into(%{
        content: "some content",
        title: "some title",
        video_url: "some video_url"
      })
      |> TimeManager.Training.create_tutorial()

    tutorial
  end
end

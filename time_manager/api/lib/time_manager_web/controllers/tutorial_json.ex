defmodule TimeManagerWeb.TutorialJSON do
  alias TimeManager.Training.Tutorial

  @doc """
  Renders a list of tutorials.
  """
  def index(%{tutorials: tutorials}) do
    %{data: for(tutorial <- tutorials, do: data(tutorial))}
  end

  @doc """
  Renders a single tutorial.
  """
  def show(%{tutorial: tutorial}) do
    %{data: data(tutorial)}
  end

  defp data(%Tutorial{} = tutorial) do
    %{
      id: tutorial.id,
      title: tutorial.title,
      content: tutorial.content,
      video_url: tutorial.video_url
    }
  end
end

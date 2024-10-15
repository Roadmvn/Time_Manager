defmodule TimeManagerWeb.TutorialController do
  use TimeManagerWeb, :controller

  alias TimeManager.Training
  alias TimeManager.Training.Tutorial

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    tutorials = Training.list_tutorials()
    render(conn, :index, tutorials: tutorials)
  end

  def create(conn, %{"tutorial" => tutorial_params}) do
    with {:ok, %Tutorial{} = tutorial} <- Training.create_tutorial(tutorial_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/tutorials/#{tutorial}")
      |> render(:show, tutorial: tutorial)
    end
  end

  def show(conn, %{"id" => id}) do
    tutorial = Training.get_tutorial!(id)
    render(conn, :show, tutorial: tutorial)
  end

  def update(conn, %{"id" => id, "tutorial" => tutorial_params}) do
    tutorial = Training.get_tutorial!(id)

    with {:ok, %Tutorial{} = tutorial} <- Training.update_tutorial(tutorial, tutorial_params) do
      render(conn, :show, tutorial: tutorial)
    end
  end

  def delete(conn, %{"id" => id}) do
    tutorial = Training.get_tutorial!(id)

    with {:ok, %Tutorial{}} <- Training.delete_tutorial(tutorial) do
      send_resp(conn, :no_content, "")
    end
  end
end

defmodule TimeManagerWeb.TutorialControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.TrainingFixtures

  alias TimeManager.Training.Tutorial

  @create_attrs %{
    content: "some content",
    title: "some title",
    video_url: "some video_url"
  }
  @update_attrs %{
    content: "some updated content",
    title: "some updated title",
    video_url: "some updated video_url"
  }
  @invalid_attrs %{content: nil, title: nil, video_url: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tutorials", %{conn: conn} do
      conn = get(conn, ~p"/api/tutorials")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create tutorial" do
    test "renders tutorial when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/tutorials", tutorial: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/tutorials/#{id}")

      assert %{
               "id" => ^id,
               "content" => "some content",
               "title" => "some title",
               "video_url" => "some video_url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/tutorials", tutorial: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update tutorial" do
    setup [:create_tutorial]

    test "renders tutorial when data is valid", %{conn: conn, tutorial: %Tutorial{id: id} = tutorial} do
      conn = put(conn, ~p"/api/tutorials/#{tutorial}", tutorial: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/tutorials/#{id}")

      assert %{
               "id" => ^id,
               "content" => "some updated content",
               "title" => "some updated title",
               "video_url" => "some updated video_url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, tutorial: tutorial} do
      conn = put(conn, ~p"/api/tutorials/#{tutorial}", tutorial: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete tutorial" do
    setup [:create_tutorial]

    test "deletes chosen tutorial", %{conn: conn, tutorial: tutorial} do
      conn = delete(conn, ~p"/api/tutorials/#{tutorial}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/tutorials/#{tutorial}")
      end
    end
  end

  defp create_tutorial(_) do
    tutorial = tutorial_fixture()
    %{tutorial: tutorial}
  end
end

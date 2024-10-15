defmodule TimeManager.TrainingTest do
  use TimeManager.DataCase

  alias TimeManager.Training

  describe "tutorials" do
    alias TimeManager.Training.Tutorial

    import TimeManager.TrainingFixtures

    @invalid_attrs %{content: nil, title: nil, video_url: nil}

    test "list_tutorials/0 returns all tutorials" do
      tutorial = tutorial_fixture()
      assert Training.list_tutorials() == [tutorial]
    end

    test "get_tutorial!/1 returns the tutorial with given id" do
      tutorial = tutorial_fixture()
      assert Training.get_tutorial!(tutorial.id) == tutorial
    end

    test "create_tutorial/1 with valid data creates a tutorial" do
      valid_attrs = %{content: "some content", title: "some title", video_url: "some video_url"}

      assert {:ok, %Tutorial{} = tutorial} = Training.create_tutorial(valid_attrs)
      assert tutorial.content == "some content"
      assert tutorial.title == "some title"
      assert tutorial.video_url == "some video_url"
    end

    test "create_tutorial/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Training.create_tutorial(@invalid_attrs)
    end

    test "update_tutorial/2 with valid data updates the tutorial" do
      tutorial = tutorial_fixture()
      update_attrs = %{content: "some updated content", title: "some updated title", video_url: "some updated video_url"}

      assert {:ok, %Tutorial{} = tutorial} = Training.update_tutorial(tutorial, update_attrs)
      assert tutorial.content == "some updated content"
      assert tutorial.title == "some updated title"
      assert tutorial.video_url == "some updated video_url"
    end

    test "update_tutorial/2 with invalid data returns error changeset" do
      tutorial = tutorial_fixture()
      assert {:error, %Ecto.Changeset{}} = Training.update_tutorial(tutorial, @invalid_attrs)
      assert tutorial == Training.get_tutorial!(tutorial.id)
    end

    test "delete_tutorial/1 deletes the tutorial" do
      tutorial = tutorial_fixture()
      assert {:ok, %Tutorial{}} = Training.delete_tutorial(tutorial)
      assert_raise Ecto.NoResultsError, fn -> Training.get_tutorial!(tutorial.id) end
    end

    test "change_tutorial/1 returns a tutorial changeset" do
      tutorial = tutorial_fixture()
      assert %Ecto.Changeset{} = Training.change_tutorial(tutorial)
    end
  end
end

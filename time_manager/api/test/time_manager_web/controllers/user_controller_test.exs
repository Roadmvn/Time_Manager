defmodule TimeManagerWeb.UserControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.AccountsFixtures

  alias TimeManager.Accounts.User

  @create_attrs %{
    email: "some email",
    username: "some username"
  }
  @update_attrs %{
    email: "some updated email",
    username: "some updated username"
  }
  @invalid_attrs %{email: nil, username: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/api/users")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some email",
               "username" => "some username"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some updated email",
               "username" => "some updated username"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user}")
      end
    end
  end

  describe "promote user to manager" do
    setup [:create_user]

    test "promotes user to manager role", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}/promote_manager")
      assert %{"id" => id, "role" => "manager"} = json_response(conn, 200)["data"]
      assert id == user.id
    end
  end

  describe "promote user to admin" do
    setup [:create_user]

    test "promotes user to admin role", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}/promote_admin")
      assert %{"id" => id, "role" => "admin"} = json_response(conn, 200)["data"]
      assert id == user.id
    end
  end

  describe "demote user" do
    setup [:create_admin_user]

    test "demotes admin to regular user", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}/demote")
      assert %{"id" => id, "role" => "user"} = json_response(conn, 200)["data"]
      assert id == user.id
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  defp create_admin_user(_) do
    user = user_fixture(%{role: "admin"})
    %{user: user}
  end
end

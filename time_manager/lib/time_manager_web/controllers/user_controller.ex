defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts
  alias TimeManager.Accounts.User

  def index(conn, %{"email" => email, "username" => username}) do
    users = Accounts.list_users(email, username)
    render(conn, :index, users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  # Les autres fonctions (create, update, delete) restent inchangées
end

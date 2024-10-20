defmodule TimeManagerWeb.AuthController do
  use TimeManagerWeb, :controller
  alias TimeManager.Accounts
  alias TimeManager.Token

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = Token.generate_and_sign(%{"user_id" => user.id, "role" => user.role})
        conn
        |> put_resp_cookie("xsrf-token", token["xsrf"], http_only: false, secure: true)
        |> render("login.json", %{user: user, token: token})
      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials"})
    end
  end

  def logout(conn, _params) do
    conn
    |> delete_resp_cookie("xsrf-token")
    |> json(%{message: "Logged out successfully"})
  end
end

defmodule TimeManagerWeb.AuthController do
  use TimeManagerWeb, :controller
  alias TimeManager.Accounts
  alias TimeManager.Token

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        extra_claims = %{
          "user_id" => user.id,
          "role" => user.role
        }
        token = Token.generate_and_sign!(extra_claims)
        #  Je ne sais pas à quoi sert la ligne du dessous donc à voir si on laisse
        {:ok, claims} = Token.verify_and_validate(token)
        conn
        |> put_resp_cookie("jwt_token", token, max_age: 86400, http_only: true, secure: true, same_site: "Strict")
        |> put_status(:ok)
        |> json(%{message: "Login successful"})
      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid email or password"})
    end
  end

  def logout(conn, _params) do
    conn
    |> delete_resp_cookie("jwt_token")
    |> put_status(:ok)
    |> json(%{message: "Logged out successfully"})
  end
end

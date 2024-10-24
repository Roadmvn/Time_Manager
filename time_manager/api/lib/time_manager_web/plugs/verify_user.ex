defmodule TimeManagerWeb.Plugs.VerifyUser do
  import Plug.Conn
  import Phoenix.Controller

  alias TimeManager.Accounts
  alias TimeManagerWeb.ErrorView
  alias TimeManager.Token

  def init(default), do: default

  def call(conn, _opts) do
    conn = fetch_cookies(conn)  # Assurez-vous de charger les cookies avant de les lire
    case fetch_jwt_token(conn) do
      {:ok, token} ->
        case verify_token(token) do
          {:ok, claims} ->
            assign(conn, :current_user, claims["user_id"])
          _ ->
            unauthenticated(conn)
        end
      _ ->
        unauthenticated(conn)
    end
  end

  defp fetch_jwt_token(conn) do
    case conn.cookies["jwt_token"] do  # Accès au cookie via conn.cookies
      nil ->
        {:error, :no_token}
      token ->
        {:ok, token}
    end
  end

  defp verify_token(token) do
    case Token.verify_and_validate(token) do
      {:ok, claims} -> {:ok, claims}
      {:error, _reason} -> {:error, :invalid_token}
    end

  end

  defp unauthenticated(conn) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: "Unauthorized", message: "Access denied"})
    |> halt()
  end
end

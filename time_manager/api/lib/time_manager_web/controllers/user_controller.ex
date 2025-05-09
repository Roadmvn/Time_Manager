defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts
  alias TimeManager.Accounts.User
  alias TimeManager.Token

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    # Extraire les paramètres nécessaires
    # Valider les données d'entrée
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        # Générer un token JWT pour le nouvel utilisateur
        # Retourner une réponse de succès avec le token
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/users/#{user}")
        |> render(:show, user: user)
      {:error, %Ecto.Changeset{} = changeset} ->
        # Gérer les erreurs de validation et retourner une réponse d'erreur appropriée
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(json: TimeManagerWeb.ChangesetJSON)
        |> render(:error, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        render(conn, :show, user: user)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(json: TimeManagerWeb.ChangesetJSON)
        |> render(:error, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def promote_to_manager(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    case Accounts.update_user(user, %{role: "manager"}) do
      {:ok, updated_user} ->
        render(conn, :show, user: updated_user)
      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(json: TimeManagerWeb.ErrorJSON)
        |> render(:"422")
    end
  end

  def promote_to_admin(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    case Accounts.update_user(user, %{role: "admin"}) do
      {:ok, updated_user} ->
        render(conn, :show, user: updated_user)
      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(json: TimeManagerWeb.ErrorJSON)
        |> render(:"422")
    end
  end

  def demote_to_user(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    case Accounts.update_user(user, %{role: "user"}) do
      {:ok, updated_user} ->
        render(conn, :show, user: updated_user)
      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(json: TimeManagerWeb.ErrorJSON)
        |> render(:"422")
    end
  end

  def get_me(conn, _params) do
    IO.inspect("BONJOURRRR")
    case Map.get(conn.req_cookies, "jwt_token") do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Missing token"})

      token ->
        secret_key = System.get_env("JWT_SECRET") || "fallback_secret"
        signer = Joken.Signer.create("HS256", secret_key)

        case Token.verify_and_validate(token) do
          {:ok, claims} ->
            user_id = claims["user_id"]
            user = Accounts.get_user!(user_id)

            conn
            |> put_status(:ok)
            |> json(%{user: user})

          {:error, _reason} ->
            conn
            |> put_status(:unauthorized)
            |> json(%{error: "Invalid token"})
        end
    end
  end
end

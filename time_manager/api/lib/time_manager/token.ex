defmodule TimeManager.Token do
  use Joken.Config

  def token_config do
    default_claims(default_exp: 60 * 60 * 24) # 24 heures
    |> add_claim("xsrf", fn -> Joken.generate_jti() end)
  end

  # def generate_and_sign_token(extra_claims \\ %{}) do
  #   IO.inspect(extra_claims.user_id)
  #   token_config()
  #   |> Joken.Config.default_claims()
  #   |> Map.merge(%{user_id: extra_claims.user_id})
  #   |> Map.merge(extra_claims)
  #   |> Joken.generate_and_sign()
  # end
  def generate_and_sign_token(extra_claims \\ %{}) do
    # Debugging pour vérifier si le user_id est bien reçu
    IO.inspect(extra_claims)

    secret_key = System.get_env("JWT_SECRET") || "une_clé_de_secours"
    signer = Joken.Signer.create("HS256", secret_key)

    # Ne pas inclure le signataire dans les claims
    claims =
      token_config()
      |> Map.merge(%{"user_id" => Integer.to_string(extra_claims[:user_id])})  # Convertir user_id en chaîne
      |> Map.merge(extra_claims)  # Gardez cette ligne pour ajouter d'autres claims si nécessaire

    # Debugging pour vérifier les claims avant de générer le token
    IO.inspect(claims)

    # Générer le token avec les claims et le signer
    case Joken.encode_and_sign(claims, signer) do
      {:ok, token, _claims} ->
        {:ok, token}

      {:error, reason} ->
        {:error, reason}
    end
  end
end

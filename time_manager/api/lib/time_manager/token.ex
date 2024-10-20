defmodule TimeManager.Token do
  use Joken.Config

  def token_config do
    default_claims(default_exp: 60 * 60 * 24) # 24 heures
    |> add_claim("xsrf", fn -> Joken.generate_jti() end)
  end

  def generate_and_sign(extra_claims) do
    extra_claims
    |> token_config()
    |> generate_and_sign()
  end
end

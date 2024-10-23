defmodule TimeManagerWeb.Guardian do
  use Guardian, otp_app: :time_manager

  alias TimeManager.Accounts

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    user = Accounts.get_user!(id)
    {:ok, user}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end

  def create_token(user) do
    {:ok, token, _claims} = encode_and_sign(user, %{role: user.role})
    token
  end
end

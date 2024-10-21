def create_token(user) do
  {:ok, token, _claims} = encode_and_sign(user, %{role: user.role})
  token
end

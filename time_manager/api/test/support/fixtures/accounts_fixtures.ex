defmodule TimeManager.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        username: "some username"
      })
      |> TimeManager.Accounts.create_user()

    user
  end

  @doc """
  Generate a role.
  """
  def role_fixture(attrs \\ %{}) do
    {:ok, role} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> TimeManager.Accounts.create_role()

    role
  end

  @doc """
  Generate a permission.
  """
  def permission_fixture(attrs \\ %{}) do
    {:ok, permission} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> TimeManager.Accounts.create_permission()

    permission
  end
end

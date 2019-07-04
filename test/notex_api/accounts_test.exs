defmodule Notex.AccountsTest do
  use Notex.DataCase
  import Notex.Factory

  alias Notex.Accounts

  describe "users" do
    alias Notex.Accounts.User

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(params_for(:user))
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "create_user/1 with valid data creates a user" do
      params = params_for(:user)
      assert {:ok, %User{} = user} = Accounts.create_user(params)
      assert user.username == params.username
    end

    test "create_user/1 with invalid data returns error changeset" do
      params = params_for(:user, username: nil)
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(params)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      params = params_for(:user)
      assert {:ok, %User{} = user} = Accounts.update_user(user, params)
      assert user.username == params.username
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      params = params_for(:user, username: "")
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, params)
      assert {:ok, ^user} = Accounts.get_user(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert {:error, :not_found} = Accounts.get_user(user.id)
    end
  end
end

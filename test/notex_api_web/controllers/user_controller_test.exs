defmodule NotexWeb.UserControllerTest do
  use NotexWeb.ConnCase
  import Notex.Factory

  alias Notex.Accounts
  alias Notex.Accounts.User

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(params_for(:user))
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      %{"username" => username} = params = string_params_for(:user)
      conn = post(conn, Routes.user_path(conn, :create), user: params)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "username" => ^username
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      params = string_params_for(:user, username: "")
      conn = post(conn, Routes.user_path(conn, :create), user: params)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      %{"username" => username} = params = string_params_for(:user)
      conn = put(conn, Routes.user_path(conn, :update, user), user: params)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "username" => ^username
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      params = string_params_for(:user, username: "")
      conn = put(conn, Routes.user_path(conn, :update, user), user: params)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end

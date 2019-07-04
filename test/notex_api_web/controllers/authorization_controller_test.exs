defmodule NotexWeb.AuthorizationControllerTest do
  use NotexWeb.ConnCase
  import Notex.Factory

  alias Notex.Accounts
  alias Notex.Accounts.User
  alias NotexWeb.Endpoint

  @password "123123"

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(params_for(:user, password: @password))
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "signup a user" do
    test "creates a new user and generates a token", %{conn: conn} do
      %{"username" => username} = params = string_params_for(:user)
      conn = post(conn, Routes.authorization_path(conn, :signup), params)

      assert %{
               "user" => %{"id" => _id, "username" => ^username},
               "token" => token
             } = json_response(conn, 201)["data"]

      Phoenix.Token.verify(Endpoint, "user_id", token, max_age: 86400)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      params = string_params_for(:user, username: "")
      conn = post(conn, Routes.authorization_path(conn, :signup), params)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "login a user" do
    setup [:create_user]

    test "renders user when data is valid", %{
      conn: conn,
      user: %User{id: id, username: username}
    } do
      params = %{"username" => username, "password" => @password}
      conn = post(conn, Routes.authorization_path(conn, :login), params)

      assert %{
               "user" => %{"id" => ^id, "username" => ^username},
               "token" => token
             } = json_response(conn, 201)["data"]

      Phoenix.Token.verify(Endpoint, "user_id", token, max_age: 86400)
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      params = %{"username" => user.username, "password" => "not_correct"}
      conn = post(conn, Routes.authorization_path(conn, :login), params)
      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end

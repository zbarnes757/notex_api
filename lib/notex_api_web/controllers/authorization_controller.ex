defmodule NotexWeb.AuthorizationController do
  use NotexWeb, :controller

  alias Notex.Accounts
  alias Notex.Accounts.User

  action_fallback NotexWeb.FallbackController

  def signup(conn, auth_params) do
    with {:ok, %User{} = user} <- Accounts.create_user(auth_params),
         token = Phoenix.Token.sign(NotexWeb.Endpoint, "user_id", user.id) do
      conn
      |> put_status(:created)
      |> json(%{
        data: %{
          user: %{
            id: user.id,
            username: user.username
          },
          token: token
        }
      })
    end
  end

  def login(conn, %{"username" => username, "password" => password}) do
    with {:ok, user} <- Accounts.get_user_by_username(username),
         {:ok, _} <- User.verify_password(user, password),
         token = Phoenix.Token.sign(NotexWeb.Endpoint, "user_id", user.id) do
      conn
      |> put_status(:created)
      |> json(%{
        data: %{
          user: %{
            id: user.id,
            username: user.username
          },
          token: token
        }
      })
    else
      {:error, :invalid} ->
        conn
        |> put_status(:unauthorized)
        |> put_view(NotexWeb.ErrorView)
        |> render(:"401")

      error ->
        error
    end
  end
end

defmodule NotexWeb.Router do
  use NotexWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", NotexWeb do
    pipe_through :api

    resources "/users", UserController, only: [:create, :show, :update]
  end
end

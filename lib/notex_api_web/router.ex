defmodule NotexWeb.Router do
  use NotexWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", NotexWeb do
    pipe_through :api

    post "/signup", AuthorizationController, :signup
    post "/login", AuthorizationController, :login
  end
end

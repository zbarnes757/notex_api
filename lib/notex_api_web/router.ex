defmodule NotexWeb.Router do
  use NotexWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", NotexWeb do
    pipe_through :api
  end
end

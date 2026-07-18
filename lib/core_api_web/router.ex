defmodule CoreApiWeb.Router do
  use CoreApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug CoreApiWeb.Authenticate
  end

  # Public routes
  scope "/api", CoreApiWeb do
    pipe_through :api

    # POST
    post "/login", AuthController, :login
    post "/register", AuthController, :register
    post "/refresh-token", AuthController, :refresh_token
  end

  # Protected routes
  scope "/api", CoreApiWeb do
    pipe_through [:api, :authenticated]

    get "/users", UsersController, :index
  end
end

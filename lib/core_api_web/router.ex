defmodule CoreApiWeb.Router do
  use CoreApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Định nghĩa các route cho API
  scope "/api", CoreApiWeb do
    pipe_through :api

    # Khai báo Router nhận request POST /api/login và chuyển tới AuthController xử lý
    post "/login", AuthController, :login
    post "/register", AuthController, :register
  end
end

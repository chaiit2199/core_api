defmodule CoreApiWeb.AuthController do
  use CoreApiWeb, :controller

  def login(conn, %{"username" => username, "password" => password}) do
    case CoreApi.Auth.login(username, password) do
      {:ok, payload} ->
        conn
        |> put_status(:ok)
        |> json(payload)

      {:error, %{message: "Tài khoản hoặc mật khẩu không chính xác"} = payload} ->
        conn
        |> put_status(:unauthorized)
        |> json(payload)

      {:error, payload} ->
        conn
        |> put_status(:internal_server_error)
        |> json(payload)
    end
  end

  def register(conn, params) do
    case CoreApi.Auth.register(params) do
      {:ok, payload} ->
        conn
        |> put_status(:created)
        |> json(payload)

      {:error, payload} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(payload)
    end
  end

  def refresh_token(conn, %{"refresh_token" => refresh_token}) do
    case CoreApi.Auth.refresh_token(refresh_token) do
      {:ok, payload} ->
        conn
        |> put_status(:ok)
        |> json(payload)

      {:error, payload} ->
        conn
        |> put_status(:unauthorized)
        |> json(payload)
    end
  end
end

defmodule CoreApi.Auth do
  @moduledoc """
  Shared authentication logic for HTTP controllers and RPC facades.
  """

  def login(username, password) do
    case CoreAuth.authenticate_user(username, password) do
      {:ok, %{access_token: access_token, refresh_token: refresh_token}} ->
        {:ok,
         %{
           message: "Đăng nhập thành công!",
           access_token: access_token,
           refresh_token: refresh_token
         }}

      {:error, :unauthorized} ->
        {:error, %{message: "Tài khoản hoặc mật khẩu không chính xác"}}
    end
  end

  def register(params) do
    case CoreAuth.register_user(params) do
      {:ok, user} ->
        {:ok,
         %{
           message: "Đăng ký tài khoản thành công!",
           user: user
         }}

      {:error, error} ->
        {:error, %{errors: error}}
    end
  end

  def refresh_token(refresh_token) do
    case Token.verify_refresh_token(refresh_token) do
      {:ok, user} ->
        with {:ok, access_token} <- Token.generate_access_token(user) do
          {:ok, %{access_token: access_token}}
        end

      {:error, _reason} ->
        {:error, %{message: "Refresh token không hợp lệ"}}
    end
  end

  def verify_access_token(access_token) do
    case Token.verify_access_token(access_token) do
      {:ok, user} -> {:ok, user}
      {:error, reason} -> {:error, reason}
    end
  end
end

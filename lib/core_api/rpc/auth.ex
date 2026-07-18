defmodule CoreApi.RPC.Auth do
  @moduledoc """
  RPC facade for auth. Called from other cluster nodes via `:erpc.call/4`.
  Returns plain maps/tuples safe to serialize across the wire.
  """

  def login(username, password) do
    CoreApi.Auth.login(username, password)
  end

  def register(attrs) do
    CoreApi.Auth.register(attrs)
  end

  def refresh_token(refresh_token) do
    CoreApi.Auth.refresh_token(refresh_token)
  end

  def verify_access_token(access_token) do
    CoreApi.Auth.verify_access_token(access_token)
  end
end

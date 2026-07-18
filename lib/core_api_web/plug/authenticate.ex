defmodule CoreApiWeb.Authenticate do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> access_token] ->
        case Token.verify_access_token(access_token) do
          {:ok, _} ->
            conn

          {:error, _} ->
            conn
            |> put_status(:unauthorized)
            |> json(%{message: "Unauthorized"})
            |> halt()
        end

      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{message: "Unauthorized"})
        |> halt()
    end
  end
end

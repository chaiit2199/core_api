defmodule CoreApiWeb.AuthController do
    use CoreApiWeb, :controller

    def login(conn, %{"username" => username, "password" => password}) do
        # password nhận từ client ở dạng thô (plain text) được truyền thẳng xuống core_auth
        case CoreAuth.authenticate_user(username, password) do
        {:ok, %{user: user, access_token: access_token, refresh_token: refresh_token}} ->
          conn
          |> put_status(:ok)
          |> json(%{
          message: "Đăng nhập thành công!",
          access_token: access_token,
          refresh_token: refresh_token,
          user: %{
              username: user.username,
              fullname: user.fullname,
              email: user.email,
              role: user.role
          }
        })

        {:error, :unauthorized} ->
            conn
            |> put_status(:unauthorized)
            |> json(%{message: "Tài khoản hoặc mật khẩu không chính xác"})

        _ ->
            conn
            |> put_status(:internal_server_error)
            |> json(%{message: "Có lỗi xảy ra trên hệ thống"})
        end
    end

    def register(conn, params) do
        case CoreAuth.register_user(params) do
          {:ok, user} ->
            conn
            |> put_status(:created)
            |> json(%{
              message: "Đăng ký tài khoản thành công!",
              user: %{
                id: user.id,
                username: user.username,
                fullname: user.fullname,
                email: user.email,
                role: user.role
              }
            })

          {:error, changeset} ->
            # Trích xuất và định dạng lỗi từ changeset để trả về cho client dễ đọc
            errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
              Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
                to_string(Keyword.get(opts, String.to_atom(key), key))
              end)
            end)

            conn
            |> put_status(:unprocessable_entity)
            |> json(%{errors: errors})
        end
    end

    def refresh_token(conn, %{"refresh_token" => refresh_token}) do
        case Token.verify_refresh_token(refresh_token) do
          {:ok, user} ->
            {:ok, access_token} = Token.generate_access_token(user)
            conn
            |> put_status(:ok)
            |> json(%{access_token: access_token})
          {:error, _} ->
            conn
            |> put_status(:unauthorized)
            |> json(%{message: "Refresh token không hợp lệ"})
        end
    end

end

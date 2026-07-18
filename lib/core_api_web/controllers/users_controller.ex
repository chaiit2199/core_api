defmodule CoreApiWeb.UsersController do
  use CoreApiWeb, :controller

  def index(conn, _params) do
    users = [
      %{id: 1, name: "John Doe"},
      %{id: 2, name: "Jane Doe"},
      %{id: 3, name: "Jim Doe"},
    ]

    conn
    |> put_status(:ok)
    |> json(users)
  end
end

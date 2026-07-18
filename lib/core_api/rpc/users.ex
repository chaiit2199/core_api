defmodule CoreApi.RPC.Users do
  @moduledoc """
  RPC facade for users. Called from other cluster nodes via `:erpc.call/4`.
  """

  def list do
    {:ok,
     [
       %{id: 1, name: "John Doe"},
       %{id: 2, name: "Jane Doe"},
       %{id: 3, name: "Jim Doe"}
     ]}
  end
end

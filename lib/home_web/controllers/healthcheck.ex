defmodule HomeWeb.Healthcheck do
  @moduledoc """
  Puts a very simple healthcheck endpoint at `/healthcheck`.

  Put this at the top of the endpoint so that it's called before the logging
  plug is enabled and these won't be logged!
  """
  import Plug.Conn

  def init(opts), do: opts

  @response Jason.encode!(%{status: :ok})

  def call(%Plug.Conn{request_path: "/healthcheck"} = conn, _opts) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, @response)
    |> halt()
  end

  def call(conn, _opts), do: conn
end

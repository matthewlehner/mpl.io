defmodule HomeWeb.Redirects do
  use HomeWeb, :controller

  def init(opts), do: opts

  def call(conn = %{request_path: "/writing/instrumenting-phoenix-with-prometheus"}, _opts),
    do: conn |> redirect(to: ~p"/writing/collecting-phoenix-metrics-with-prometheus") |> halt()

  def call(conn, _opts), do: conn
end

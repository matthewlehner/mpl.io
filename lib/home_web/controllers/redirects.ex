defmodule HomeWeb.Redirects do
  use HomeWeb, :controller

  def init(opts), do: opts

  def call(%{request_path: "/writing/instrumenting-phoenix-with-prometheus"} = conn, _opts),
    do: conn |> redirect(to: ~p"/writing/collecting-phoenix-metrics-with-prometheus") |> halt()

  def call(%{request_path: "/adhd-dtc"} = conn, _opts),
    do:
      conn
      |> redirect(
        external:
          "https://reflect.site/g/mpl/disability-tax-credit-for-adhd/b58bed37edcb48d8b9b9c67f7863278a"
      )

  def call(conn, _opts), do: conn
end

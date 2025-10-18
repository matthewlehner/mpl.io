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

  def call(%{request_path: "/basic-133-guides"} = conn, _opts),
    do:
      redirect(conn,
        external:
          "https://reflect.site/g/mpl/addca-basic-coaching-133/5c90e909e749461d8de3835d7b5d82f0"
      )

  def call(conn, _opts), do: conn
end

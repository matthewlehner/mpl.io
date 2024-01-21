defmodule HomeWeb.PageController do
  use HomeWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    conn
    |> assign(:page_title, "Software developer, technical founder")
    |> render(:home)
  end
end

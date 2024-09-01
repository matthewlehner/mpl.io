defmodule HomeWeb.PageController do
  use HomeWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    conn
    |> assign(:page_title, "Software developer, technical founder")
    |> render(:home)
  end

  def cv(conn, _params) do
    conn
    |> assign(:page_title, "Work Experience")
    |> assign(:roles, Home.CV.roles())
    |> render(:resume)
  end
end

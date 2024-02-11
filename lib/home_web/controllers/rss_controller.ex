defmodule HomeWeb.RSSController do
  use HomeWeb, :controller

  plug :accepts, ["xml"]
  plug :put_layout, false
  plug :put_root_layout, false

  def index(conn, _params) do
    articles = Home.Blog.all_articles()
    last_build_date = articles |> List.first() |> Map.get(:date)

    conn
    |> put_view(xml: HomeWeb.RSSXML)
    |> put_resp_content_type("text/xml")
    |> render("index.xml", articles: articles, last_build_date: last_build_date)
  end
end

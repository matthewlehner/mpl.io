defmodule HomeWeb.ArticleController do
  use HomeWeb, :controller

  def index(conn, _params) do
    conn
    |> assign(:page_title, "Articles")
    |> render(:index, articles: Home.Blog.all_articles())
  end

  def show(conn, %{"id" => id}) do
    article = Home.Blog.get_article!(id)

    conn
    |> assign(:page_title, article.title)
    |> render(:show, article: article)
  end
end

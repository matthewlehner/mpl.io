defmodule Home.Blog do
  @moduledoc """
  Logic for the blog. Articles and such.
  """

  alias Home.Blog.Article

  use NimblePublisher,
    build: Article,
    from: Application.app_dir(:home, "priv/articles/**/*.md"),
    as: :articles,
    highlighters: [:makeup_elixir, :makeup_html, :makeup_js]

  @articles @articles |> Enum.reject(& &1.draft) |> Enum.sort_by(& &1.date, {:desc, Date})

  def all_articles, do: @articles

  def get_article!(id) do
    Enum.find(all_articles(), &(&1.id == id)) ||
      raise NotFoundError, "article with id=#{id} not found"
  end
end

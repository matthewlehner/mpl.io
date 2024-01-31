defmodule Home.Blog do
  @moduledoc """
  Logic for the blog. Articles and such.
  """

  alias Home.Blog.Article

  use NimblePublisher,
    build: Article,
    from: Application.app_dir(:home, "priv/articles/**/*.md"),
    as: :articles

  @articles Enum.sort_by(@articles, & &1.date, {:desc, Date})

  def all_articles, do: @articles

  def get_article!(id) do
    Enum.find(all_articles(), &(&1.id == id)) ||
      raise NotFoundError, "article with id=#{id} not found"
  end

  def markdown_to_html(content), do: Earmark.as_html(content)
end

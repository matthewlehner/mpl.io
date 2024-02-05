defmodule HomeWeb.ArticleHTML do
  use HomeWeb, :html

  embed_templates "article_html/*"

  attr :date, Date, required: true
  attr :rest, :global

  def published_at(assigns) do
    ~H"""
    <time {@rest} datetime={@date}><%= format_date(@date) %></time>
    """
  end

  defp format_date(date) do
    Calendar.strftime(date, "%B %-d, %Y")
  end
end

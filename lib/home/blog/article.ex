defmodule Home.Blog.Article do
  @enforce_keys [:id, :title, :body, :description, :date, :draft]
  defstruct [:id, :title, :body, :description, :date, draft: false]

  def build(filename, attrs, body) do
    [month_day_id] =
      filename
      |> Path.rootname()
      |> Path.split()
      |> Enum.take(-1)

    [year, month, day, id] =
      String.split(month_day_id, "-", parts: 4)

    date = Date.from_iso8601!("#{year}-#{month}-#{day}")
    struct(__MODULE__, Keyword.merge(Map.to_list(attrs), id: id, date: date, body: body))
  end
end

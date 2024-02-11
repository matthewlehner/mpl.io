defmodule HomeWeb.RSSXML do
  use HomeWeb, :html

  embed_templates "rss_xml/*"

  def to_rfc822(%Date{} = date) do
    date
    |> DateTime.new!(~T[00:00:00], "America/Vancouver")
    |> Calendar.strftime("%a, %d %b %Y %H:%M:%S %Z")
  end
end

defmodule HomeWeb.ErrorHTMLTest do
  use HomeWeb.ConnCase, async: true

  # Bring render_to_string/4 for testing custom views
  import Phoenix.Template

  test "renders 404.html" do
    assert render_to_string(HomeWeb.ErrorHTML, "404", "html", []) =~ "4 oh 4"
  end

  test "renders 500.html" do
    assert render_to_string(HomeWeb.ErrorHTML, "500", "html", []) =~ "Exceptional!"
  end
end

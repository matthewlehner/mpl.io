defmodule HomeWeb.PageControllerTest do
  use HomeWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")

    assert html_response(conn, 200) =~
             "Software developer, technical founder, and people focused leader"
  end
end

defmodule NightcrawlerWeb.PageControllerTest do
  @moduledoc false
  use NightcrawlerWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Nightcrawler is a utility to create playlists and search for marvel comics"
  end
end

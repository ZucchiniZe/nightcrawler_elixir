defmodule NightcrawlerWeb.PageController do
  use NightcrawlerWeb, :controller
  alias Nightcrawler.Marvel

  def index(conn, _params) do
    render conn, "index.html"
  end

  def comics(conn, params) do
    id = Map.get(params, "comic_id")
    case Marvel.get_comics(id) do
      {:ok, response} -> # the page was already cached
        json conn, response
      {:commit, response} -> # the page was uncached and now is cached
        json conn, response
    end
  end
end

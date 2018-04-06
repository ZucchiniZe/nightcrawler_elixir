defmodule NightcrawlerWeb.PageController do
  use NightcrawlerWeb, :controller
  alias Nightcrawler.Marvel

  def index(conn, _params) do
    render conn, "index.html"
  end

  def comics(conn, params) do
    id = Map.get(params, "comic_id")
    case Marvel.get_comics(id) do
      {:ok, response} ->
        json conn, response.body
    end
  end
end

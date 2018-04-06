defmodule NightcrawlerWeb.PageController do
  use NightcrawlerWeb, :controller
  alias Nightcrawler.Marvel

  def index(conn, _params) do
    render conn, "index.html"
  end

  def comics(conn, %{"comic_id" => id} = params) do
    case Marvel.get_comics(id) do
      {:ok, response} ->
        json conn, response.body
    end
  end
end

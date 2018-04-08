defmodule NightcrawlerWeb.PageController do
  use NightcrawlerWeb, :controller
  alias Nightcrawler.Marvel
  require Logger

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def comics(conn, params) do
    id = Map.get(params, "comic_id")

    case Marvel.get_comics(id, []) do
      # the page was already cached
      {:ok, response} ->
        json(conn, response.body)

      {:error, error} ->
        Logger.error(error)
    end
  end

  def cache_stats(conn, _params) do
    {:ok, stats} = Cachex.stats(:marvel_cache)
    json(conn, stats)
  end
end

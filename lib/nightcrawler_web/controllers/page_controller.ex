defmodule NightcrawlerWeb.PageController do
  use NightcrawlerWeb, :controller
  alias Nightcrawler.Marvel
  require Logger

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def cache_stats(conn, _params) do
    {:ok, stats} = Cachex.stats(:marvel_cache)
    json(conn, stats)
  end
end

defmodule NightcrawlerWeb.PageController do
  use NightcrawlerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def cache_stats(conn, _params) do
    case Cachex.stats(:marvel_cache) do
      {:ok, stats} ->
        json(conn, stats)

      {:error, reason} ->
        text(conn, reason)
    end
  end
end

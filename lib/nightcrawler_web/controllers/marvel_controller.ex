defmodule NightcrawlerWeb.MarvelController do
  use NightcrawlerWeb, :controller
  alias Nightcrawler.Marvel
  require Logger

  def comics_all(conn, _params) do
    case Marvel.get_comics(nil, limit: 100) do
      {:ok, response} ->
        json(conn, response.body)

      {:error, error} ->
        Logger.error(error)
    end
  end

  def comics(conn, %{"id" => id}) do
    case Marvel.get_comics(id, []) do
      {:ok, response} ->
        json(conn, response.body)

      {:error, error} ->
        Logger.error(error)
    end
  end

  def series_all(conn, _params) do
    case Marvel.get_series(nil, limit: 100) do
      {:ok, response} ->
        render(conn, "series_index.html", data: response.body["data"]["results"])

      {:error, error} ->
        Logger.error(error)
    end
  end

  def series(conn, %{"id" => id}) do
    case Marvel.get_series(id, []) do
      {:ok, response} ->
        json(conn, response.body)

      {:error, error} ->
        Logger.error(error)
    end
  end
end

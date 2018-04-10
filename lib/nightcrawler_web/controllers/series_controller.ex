defmodule NightcrawlerWeb.SeriesController do
  use NightcrawlerWeb, :controller
  alias Nightcrawler.Marvel
  require Logger

  def all(conn, _params) do
    case Marvel.get_series(nil, limit: 100) do
      {:ok, response} ->
        render(conn, "index.html", data: response.body["data"]["results"])

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

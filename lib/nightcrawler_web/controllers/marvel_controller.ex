defmodule NightcrawlerWeb.MarvelController do
  use NightcrawlerWeb, :controller
  alias Nightcrawler.Marvel
  require Logger

  def series_all(conn, _params) do
    case Marvel.get_series(nil, [limit: 100]) do
      {:ok, response} ->
        render(conn, "series_index.html", data: response.body["data"]["results"])
        # json conn, response.body

      {:error, error} ->
        Logger.error(error)
    end
  end
end

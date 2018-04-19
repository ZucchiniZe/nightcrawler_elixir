defmodule NightcrawlerWeb.SeriesController do
  use NightcrawlerWeb, :controller
  alias Nightcrawler.Marvel.API, as: Marvel
  require Logger

  def all(conn, _params) do
    {:ok, response} = Marvel.get_series(nil, limit: 100)

    if response.status == 200 do
      render(conn, "index.html", data: response.body["data"]["results"])
    else
      conn
      |> put_status(response.status)
      |> json(response.body)
    end
  end

  def get(conn, %{"id" => id}) do
    case Marvel.get_series(id, []) do
      {:ok, response} ->
        # returns a single element array so make sure to return that element
        render conn, "get.html", data: response.body["data"]["results"] |> List.first

      {:error, error} ->
        Logger.error(error)
    end
  end
end

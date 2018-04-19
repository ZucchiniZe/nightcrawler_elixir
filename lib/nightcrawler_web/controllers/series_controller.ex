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
    {:ok, response} = Marvel.get_series(id, [])

    if response.status == 200 do
      render conn, "get.html", data: response.body["data"]["results"] |> List.first
    else
      conn
      |> put_status(response.status)
      |> json(response.body)
    end
  end
end

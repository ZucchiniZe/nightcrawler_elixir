defmodule NightcrawlerWeb.SeriesController do
  use NightcrawlerWeb, :controller
  alias Marvel
  require Logger

  def all(conn, params) do
    page = Map.get(params, "page", "1")
    req_params = get_page(100, page)

    {:ok, response} = Marvel.get_series(nil, req_params)

    if response.status == 200 do
      render conn, "index.html", data: response.body["data"]["results"]
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

  defp get_page(per_page, page) do
    n = String.to_integer(page)
    [offset: (n - 1) * per_page, limit: per_page]
  end
end

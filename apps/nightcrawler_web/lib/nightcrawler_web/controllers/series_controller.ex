defmodule NightcrawlerWeb.SeriesController do
  use NightcrawlerWeb, :controller
  import Ecto.Query, only: [from: 2]
  alias Nightcrawler.Marvel.{Comic, Series}

  def index(conn, _params) do
    # series = Nightcrawler.Marvel.list_series() |> Nightcrawler.Repo.preload(:comics)
    comic_query = from comic in Comic, order_by: [desc: comic.issue_number]

    query =
      from series in Series,
        preload: [comics: ^comic_query],
        limit: 50

    series = query |> Nightcrawler.Repo.all()

    render(conn, "index.html", series: series)
  end

  def get(conn, %{"id" => id}) do
    comic_query = from comic in Comic, order_by: comic.issue_number

    query =
      from s in Series,
      preload: [comics: ^comic_query],
      where: s.id == ^id

    series = query |> Nightcrawler.Repo.one()

    render(conn, "get.html", series: series)
  end
end

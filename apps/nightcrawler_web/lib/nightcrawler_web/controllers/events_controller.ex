defmodule NightcrawlerWeb.EventsController do
  use NightcrawlerWeb, :controller

  def index(conn, _params) do
    events = Nightcrawler.Marvel.list_events()

    render(conn, "index.html", events: events)
  end
end

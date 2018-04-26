defmodule NightcrawlerWeb.EventsController do
  use NightcrawlerWeb, :controller

  def all(conn, _params) do
    events = Nightcrawler.Marvel.list_events()

    json(conn, events)
  end
end

defmodule NightcrawlerWeb.EventsController do
  use NightcrawlerWeb, :controller

  def index(conn, _params) do
    events = Nightcrawler.Marvel.list_events()

    json(conn, length(events))
  end
end

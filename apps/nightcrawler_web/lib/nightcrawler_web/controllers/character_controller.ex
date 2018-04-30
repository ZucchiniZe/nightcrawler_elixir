defmodule NightcrawlerWeb.CharacterController do
  use NightcrawlerWeb, :controller

  def all(conn, _params) do
    chars = Nightcrawler.Marvel.list_characters

    render(conn, "index.html", characters: chars)
  end
end

defmodule NightcrawlerWeb.MarvelView do
  use NightcrawlerWeb, :view

  def thumbnail(series) do
    "#{series["thumbnail"]["path"]}.#{series["thumbnail"]["extension"]}"
  end
end
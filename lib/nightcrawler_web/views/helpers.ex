defmodule NightcrawlerWeb.Helpers do
  def thumbnail(series) do
    "#{series["thumbnail"]["path"]}.#{series["thumbnail"]["extension"]}"
  end
end
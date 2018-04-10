defmodule NightcrawlerWeb.SeriesView do
  use NightcrawlerWeb, :view

  def last_five(comics) do
    comics
    |> Enum.reverse
    |> Enum.take(5)
  end
end
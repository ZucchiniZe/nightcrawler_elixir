defmodule NightcrawlerWeb.Helpers do
  @moduledoc """
  Universal view helpers for the nightcrawler application
  """

  def thumbnail(series, variant) do
    thumb = series["thumbnail"]

    url =
      thumb["path"]
      |> URI.parse()
      |> Map.put(:scheme, "https")
      |> Map.put(:port, nil)
      |> URI.to_string()

    "#{url}/#{to_string(variant)}.#{thumb["extension"]}"
  end
end

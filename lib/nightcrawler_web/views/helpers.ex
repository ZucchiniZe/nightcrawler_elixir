defmodule NightcrawlerWeb.Helpers do
  def thumbnail(series) do
    thumb = series["thumbnail"]

    url =
      URI.parse(thumb["path"])
      |> Map.put(:scheme, "https")
      |> Map.put(:port, nil)
      |> URI.to_string()

    "#{url}.#{thumb["extension"]}"
  end
end

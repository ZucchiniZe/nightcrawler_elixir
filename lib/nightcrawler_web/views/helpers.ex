defmodule NightcrawlerWeb.Helpers do
  def thumbnail(series, variant) do
    thumb = series["thumbnail"]

    url =
      URI.parse(thumb["path"])
      |> Map.put(:scheme, "https")
      |> Map.put(:port, nil)
      |> URI.to_string()

    "#{url}/#{to_string(variant)}.#{thumb["extension"]}"
  end
end

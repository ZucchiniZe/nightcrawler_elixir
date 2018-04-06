defmodule Nightcrawler.Marvel do
  use Tesla

  # plug Tesla.Middleware.Logger
  plug Tesla.Middleware.BaseUrl, "https://gateway.marvel.com/v1/public"
  plug Nightcrawler.Marvel.Auth
  plug Tesla.Middleware.JSON

  def get_comics, do: get("/comics")
  def get_comics(nil), do: get("/comics")
  def get_comics(id), do: get("/comics/#{id}")
end

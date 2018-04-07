defmodule Nightcrawler.Marvel do
  @moduledoc """
  Marvel API Wrapper
  Uses Tesla to make requests with special middleware to satisfy marvel auth
  and uses Cachex to cache the calls for greater response times.
  """
  use Tesla
  @version Mix.Project.config[:version]

  # plug Tesla.Middleware.Logger
  plug Tesla.Middleware.BaseUrl, "https://gateway.marvel.com/v1/public"
  plug Tesla.Middleware.Headers, [{"User-Agent", "nightcrawler/#{@version}"}]
  plug Nightcrawler.Marvel.Middleware.Auth
  plug Nightcrawler.Marvel.Middleware.Cache, ttl: :timer.hours(12)
  plug Tesla.Middleware.DecodeJson

  ### Comics

  def get_comics(nil, query \\ []), do: get("/comics", query: query)
  def get_comics(id, query \\ []), do: get("/comics/#{id}", query: query)
  def get_comics_characters(id, query \\ []), do: get("/comics/#{id}/characters", query: query)
  def get_comics_creators(id, query \\ []), do: get("/comics/#{id}/creators", query: query)
  def get_comics_events(id, query \\ []), do: get("/comics/#{id}/events", query: query)
  def get_comics_stories(id, query \\ []), do: get("/comics/#{id}/stories", query: query)
end

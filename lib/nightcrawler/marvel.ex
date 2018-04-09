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
  plug Nightcrawler.Marvel.Middleware.Cache
  plug Nightcrawler.Marvel.Middleware.Auth
  plug Tesla.Middleware.DecodeJson

  ### Characters
  # All of the marvel API character routes

  def get_characters(nil, query), do: get("/characters", query: query)
  def get_characters(id, query), do: get("/characters/#{id}", query: query)
  def get_characters_comics(id, query), do: get("/characters/#{id}/comics", query: query)
  def get_characters_events(id, query), do: get("/characters/#{id}/events", query: query)
  def get_characters_series(id, query), do: get("/characters/#{id}/series", query: query)
  def get_characters_stories(id, query), do: get("/characters/#{id}/stories", query: query)

  ### Comics
  # All of the marvel API comic routes

  def get_comics(nil, query), do: get("/comics", query: query)
  def get_comics(id, query), do: get("/comics/#{id}", query: query)
  def get_comics_characters(id, query), do: get("/comics/#{id}/characters", query: query)
  def get_comics_creators(id, query), do: get("/comics/#{id}/creators", query: query)
  def get_comics_events(id, query), do: get("/comics/#{id}/events", query: query)
  def get_comics_stories(id, query), do: get("/comics/#{id}/stories", query: query)

  ### Creators
  # All of the marvel API creator routes

  def get_creators(nil, query), do: get("/creators", query: query)
  def get_creators(id, query), do: get("/creators/#{id}", query: query)
  def get_creators_comics(id, query), do: get("/creators/#{id}/comics", query: query)
  def get_creators_events(id, query), do: get("/creators/#{id}/events", query: query)
  def get_creators_series(id, query), do: get("/creators/#{id}/series", query: query)
  def get_creators_stories(id, query), do: get("/creators/#{id}/stories", query: query)

  ### Events
  # All of the marvel API event routes

  def get_events(nil, query), do: get("/events", query: query)
  def get_events(id, query), do: get("/events/#{id}", query: query)
  def get_events_characters(id, query), do: get("/events/#{id}/characters", query: query)
  def get_events_comics(id, query), do: get("/events/#{id}/comics", query: query)
  def get_events_creators(id, query), do: get("/events/#{id}/creators", query: query)
  def get_events_series(id, query), do: get("/events/#{id}/series", query: query)
  def get_events_stories(id, query), do: get("/events/#{id}/stories", query: query)

  ### Series
  # All of the marvel API series routes

  def get_series(nil, query), do: get("/series", query: query)
  def get_series(id, query), do: get("/series/#{id}", query: query)
  def get_series_characters(id, query), do: get("/series/#{id}/characters", query: query)
  def get_series_comics(id, query), do: get("/series/#{id}/comics", query: query)
  def get_series_creators(id, query), do: get("/series/#{id}/creators", query: query)
  def get_series_events(id, query), do: get("/series/#{id}/events", query: query)
  def get_series_stories(id, query), do: get("/series/#{id}/stories", query: query)

  ### Stories
  # All of the marvel API story routes

  def get_stories(nil, query), do: get("/stories", query: query)
  def get_stories(id, query), do: get("/stories/#{id}", query: query)
  def get_stories_characters(id, query), do: get("/stories/#{id}/characters", query: query)
  def get_stories_comics(id, query), do: get("/stories/#{id}/comics", query: query)
  def get_stories_creators(id, query), do: get("/stories/#{id}/creators", query: query)
  def get_stories_events(id, query), do: get("/stories/#{id}/events", query: query)
  def get_stories_series(id, query), do: get("/stories/#{id}/series", query: query)
end

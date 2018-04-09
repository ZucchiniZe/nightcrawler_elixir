defmodule Nightcrawler.Marvel.Middleware.Cache do
  @moduledoc """
  Caches all of the requests for a specified amount of time using cachex
  """
  @behaviour Tesla.Middleware
  require Logger

  def call(env, next, options) do
    # do the actual caching of the value and if it isn't cached, fetch it
    url = "#{env.url}?#{URI.encode_query(env.query)}"

    cached_value =
      Cachex.fetch(:marvel_cache, url, fn ->
        {:commit, Tesla.run(env, next)}
      end)

    # extracting the value from the cachex api
    case cached_value do
      {:ok, val} ->
        Logger.debug("cache hit for #{url}")
        val

      {:commit, val} ->
        Logger.debug("uncached, populating #{url}")
        val
    end
  end
end

defmodule Nightcrawler.Marvel.Middleware.Cache do
  @moduledoc """
  Caches all of the requests for a specified amount of time using cachex
  """
  @behaviour Tesla.Middleware

  def call(env, next, _options) do
    # do the actual caching of the value and if it isn't cached, fetch it
    url = "#{env.url}?#{URI.encode_query(env.query)}"

    cached_value =
      Cachex.fetch(:marvel_cache, url, fn ->
        {:commit, Tesla.run(env, next)}
      end)

    # extracting the value from the cachex api
    case cached_value do
      {:ok, val} ->
        val

      {:commit, val} ->
        val
    end
  end
end

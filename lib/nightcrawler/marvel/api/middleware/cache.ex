defmodule Nightcrawler.Marvel.API.Middleware.Cache do
  @moduledoc """
  Caches all of the requests for a specified amount of time using cachex
  """
  @behaviour Tesla.Middleware

  def call(env, next, _options) do
    # do the actual caching of the value and if it isn't cached, fetch it
    url = "#{env.url}?#{URI.encode_query(env.query)}"

    # we don't really need to know about the keyword associated with the value
    {_, cached_value} =
      Cachex.fetch(:marvel_cache, url, fn ->
        {:ok, response} = Tesla.run(env, next)

        if response.status == 200 do
          {:commit, response}
        else
          {:ignore, response}
        end
      end)

    {:ok, cached_value}
  end
end

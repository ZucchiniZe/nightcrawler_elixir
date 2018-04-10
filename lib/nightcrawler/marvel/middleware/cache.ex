defmodule Nightcrawler.Marvel.Middleware.Cache do
  @moduledoc """
  Caches all of the requests for a specified amount of time using cachex
  """
  @behaviour Tesla.Middleware

  def call(env, next, _opts) do
    url = "#{env.url}?#{URI.encode_query(env.query)}"

    env
    # check's the cache to see if it already exists
    |> check_cache(url)
    # if already exists, send value
    |> run(next, url)
    # cache value and send response
    |> cache_response(url)
  end

  # checks to see if the cache already exists, if so, send a {:hit, current_env}
  defp check_cache(env, url) do
    {:ok, exists} = Cachex.exists?(:marvel_cache, url)

    case exists do
      false -> {:miss, env}
      true -> {:hit, env}
    end
  end

  # checks to see if cache was hit or miss, if hit, get cached value,
  # if miss, continue request
  defp run(token, next, url) do
    {cache, env} = token

    case cache do
      :hit -> {:hit, Cachex.get(:marvel_cache, url)}
      :miss -> {:miss, Tesla.run(env, next)}
    end
  end

  # if miss, take the finished request and store it
  # if hit, return cached value
  defp cache_response(token, url) do
    {cache, {:ok, env}} = token

    case cache do
      :miss ->
        if env.status == 200 do
          Cachex.put(:marvel_cache, url, env)
          {:ok, env}
        else
          {:ok, env}
        end

      # value was already cached in above function
      :hit -> {:ok, env}
    end
  end
end

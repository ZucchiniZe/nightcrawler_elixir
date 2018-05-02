defmodule Marvel.Middleware.Cache do
  @moduledoc """
  Caches all of the requests for a specified amount of time using cachex
  """
  @behaviour Tesla.Middleware

  def call(env, next, _options) do
    url = "#{env.url}?#{URI.encode_query(env.query)}"

    # do the actual caching of the value and if it isn't cached, fetch it
    cache_fetch = fn ->
      case Tesla.run(env, next) do
        {:ok, resp} ->
          key = if resp.status in 200..299, do: :commit, else: :ignore
          {key, resp}

        {:error, _} = error ->
          {:ignore, error}
      end
    end

    case Cachex.fetch(:marvel_cache, url, cache_fetch, timeout: 10_000) do
      {:ignore, {:error, err}} ->
        {:error, err}

      {:ok, resp} ->
        {:ok, resp}

      {:commit, resp} ->
        {:ok, resp}

      {:ignore, resp} ->
        {:ok, resp}
    end
  end
end

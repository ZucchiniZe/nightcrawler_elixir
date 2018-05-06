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
          # return :commit if we get a 2xx status, otherwise ignore the value so
          # we don't cache it
          # credo:disable-for-next-line Credo.Check.Refactor.Nesting
          key = if resp.status in 200..299, do: :commit, else: :ignore
          {key, resp}

        # if tesla returns an error, just pass the entire tuple back
        {:error, _} = error ->
          {:ignore, error}
      end
    end

    case Cachex.fetch(:marvel_cache, url, cache_fetch, timeout: 10_000) do
      # if we get an actual error, send an error down the tesla tree
      {:ignore, {:error, err}} ->
        {:error, err}

      # cache hit, return value
      {:ok, resp} ->
        {:ok, resp}

      # cache miss, return value
      {:commit, resp} ->
        {:ok, resp}

      # we don't have an error but it's not a 2xx value so don't cache but pass down
      # response. likely a 4xx or 5xx error.
      {:ignore, resp} ->
        {:ok, resp}
    end
  end
end

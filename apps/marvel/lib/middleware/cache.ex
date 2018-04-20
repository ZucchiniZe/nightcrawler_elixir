defmodule Marvel.Middleware.Cache do
  @moduledoc """
  Caches all of the requests for a specified amount of time using cachex
  """
  @behaviour Tesla.Middleware

  def call(env, next, _options) do
    # do the actual caching of the value and if it isn't cached, fetch it
    url = "#{env.url}?#{URI.encode_query(env.query)}"

    {_, value} =
      Cachex.fetch(:marvel_cache, url, fn ->
        {:ok, response} = Tesla.run(env, next)

        if response.status == 200 do
          {:commit, response}
        else
          {:ignore, response}
        end
      end)

    {:ok, value}
  end
end

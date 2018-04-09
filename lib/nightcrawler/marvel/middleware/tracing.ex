defmodule Nightcrawler.Marvel.Middleware.Tracing do
  @behaviour Tesla.Middleware
  import ScoutApm.Tracing

  def call(env, next, _opts) do
    url = "#{env.url}?#{URI.encode_query(env.query)}"
    {:ok, cached} = Cachex.exists?(:marvel_cache, url)
    if cached do
      timing("Cache", env.method) do
        update_desc(url)
        Tesla.run(env, next)
      end
    else
      timing("HTTP", env.method) do
        update_desc(url)
        Tesla.run(env, next)
      end
    end
  end
end
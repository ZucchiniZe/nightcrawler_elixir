defmodule Marvel.Middleware.Tracing do
  @moduledoc """
  A middleware for tesla to add {HTTP,Cache} requests
  to the Scout APM DevTrace helper
  """

  @behaviour Tesla.Middleware
  import ScoutApm.Tracing

  def call(env, next, _opts) do
    url = "#{env.url}?#{URI.encode_query(env.query)}"

    {:ok, cached} = Cachex.exists?(:marvel_cache, url)

    type = if cached, do: "Cache", else: "HTTP"

    timing(type, env.method) do
      update_desc(url)
      Tesla.run(env, next)
    end
  end
end

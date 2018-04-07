defmodule Nightcrawler.Marvel.Middleware.Cache do
  @moduledoc """
  Caches all of the requests for a specified amount of time using cachex
  """
  @behaviour Tesla.Middleware

  def call(env, next, [ttl: ttl]) do
    env
    |> get_cached_value(env.method)
    |> run(next)
    |> set_cached_value(ttl)
  end

  defp get_cached_value(env, :get), do: {Cachex.get!(:marvel_cache, env.url), env}
  defp get_cached_value(env, nil), do: {nil, env}

  defp run({nil, env}, next), do: {:miss, Tesla.run(env, next)}
  defp run({cached_env, _env}, _next), do: {:hit, cached_env}

  defp set_cached_value({:miss, %Tesla.Env{status: status} = env}, ttl) when status == 200 do
    Cachex.put(:marvel_cache, env.url, env, ttl: ttl)
    env
  end
  defp set_cached_value({:miss, env}, _ttl), do: env
  defp set_cached_value({:miss, env}, _ttl), do: env
end
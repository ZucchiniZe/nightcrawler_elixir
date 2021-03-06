defmodule Marvel.Middleware.Auth do
  @moduledoc """
  Marvel requires a special authentication system for server side applications
  accessing their API, this middleware implements that said authentication system
  """
  @behaviour Tesla.Middleware
  require Logger

  @doc """
  The middleware function to satisfy tesla
  """
  def call(env, next, _options) do
    env
    |> add_auth
    |> Tesla.run(next)
  end

  # Takes the current timestamp in milliseconds, then makes a string to hash
  # using md5, then attaches said string to the query parameters.
  defp add_auth(env) do
    timestamp = :os.system_time(:millisecond)
    private_key = Application.get_env(:marvel, :private_key)
    public_key = Application.get_env(:marvel, :public_key)
    # because some of these things aren't strings already we need to interpolate
    hash_string = "#{timestamp}#{private_key}#{public_key}"

    hash =
      :crypto.hash(:md5, hash_string)
      # marvel needs the md5 in lowercase for some reason :/
      |> Base.encode16(case: :lower)

    auth_query = [ts: timestamp, apikey: public_key, hash: hash]

    Map.update!(env, :query, &(&1 ++ auth_query))
  end
end

defmodule Marvel.Middleware.ExponentialRetry do
  @moduledoc """
  An exponential backoff system for retrying failed HTTP requests
  """
  @behaviour Tesla.Middleware
  @initial_value 10
  @defaults [
    max_retries: 10
  ]
  require Logger

  def call(env, next, opts) do
    attempt_cap = Keyword.get(opts, :max_retries, @defaults[:max_retries])

    retry(env, next, 0, attempt_cap)
  end

  def retry(env, next, tries_so_far, cap) when cap <= 1 do
    Logger.error("retry ##{tries_so_far}. last attempt")
    Tesla.run(env, next)
  end

  def retry(env, next, tries_so_far, cap) do
    case Tesla.run(env, next) do
      {:ok, _} = resp ->
        resp

      {:error, reason} ->
        delay = exp_backoff(tries_so_far)
        Logger.error("request failed because of #{inspect reason}, retry ##{tries_so_far}. waiting #{delay}ms")

        :timer.sleep(delay)

        retry(env, next, tries_so_far + 1, cap - 1)
    end
  end

  defp exp_backoff(0), do: @initial_value
  defp exp_backoff(n) do
    :erlang.round(@initial_value * :math.pow(2, n))
  end
end

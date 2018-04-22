defmodule Marvel do
  @moduledoc """
  Marvel API Wrapper
  Uses Tesla to make requests with special middleware to satisfy marvel auth
  and uses Cachex to cache the calls for greater response times.
  """
  use Tesla
  @version Mix.Project.config()[:version]

  # use hackney because it certifies https by default
  adapter(Tesla.Adapter.Hackney)

  plug(Tesla.Middleware.BaseUrl, "https://gateway.marvel.com/v1/public")
  plug(Tesla.Middleware.Headers, [{"User-Agent", "nightcrawler/#{@version}"}])
  plug(Tesla.Middleware.Timeout, timeout: 10_000)
  plug(Tesla.Middleware.DecodeJson)
  plug(Tesla.Middleware.Logger)
  plug(Marvel.Middleware.Tracing)
  plug(Marvel.Middleware.Cache)
  plug(Marvel.Middleware.Auth)

  def get_all(url, per_page, total) do
    IO.puts("getting #{url} with #{per_page} results/page and #{total} total results")
    Process.sleep(500)

    :lists.seq(0, total, per_page)
    |> Enum.map(&Task.async(fn -> get_all_async(url, per_page, &1) end))
    |> Enum.map(&Task.await(&1, 20_000))
  end

  def get_all_async(url, limit, offset) do
    IO.puts("making a request to #{url} with limit:#{limit} & offset:#{offset}")
    sleep = Enum.random(1000..10_000)
    Process.sleep(sleep)
    IO.puts("GET http://marvel/#{url}?limit=#{limit}&offset=#{offset}")
    {:ok, %{body: "yay you got #{limit} items in #{sleep}ms"}}
  end
end

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

  @doc """
  For any resources that returns a collection that is more than 100 (enforced limit)
  """
  def get_all(url, limit) do
    initial_response = get!(url, query: [limit: 1])
    total = initial_response.body["data"]["total"]

    :lists.seq(1, total, limit)
    |> Enum.map(
      &Task.async(fn ->
        get(url, query: [limit: limit, offset: &1])
      end)
    )
    |> Enum.map(&Task.await(&1, 20_000))
    |> Enum.map(fn {:ok, resp} ->
      Map.from_struct(resp) |> Map.delete(:body)
    end)
  end
end

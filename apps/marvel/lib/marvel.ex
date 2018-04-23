defmodule Marvel do
  @moduledoc """
  Marvel API Wrapper
  Uses Tesla to make requests with special middleware to satisfy marvel auth
  and uses Cachex to cache the calls for greater response times.
  """
  use Tesla
  @version Mix.Project.config()[:version]
  @app Application.get_env(:marvel, :client_name)

  # we want to be able to not request the actual api while testing
  unless Mix.env() == :test,
    do: plug(Tesla.Middleware.BaseUrl, "https://gateway.marvel.com/v1/public")

  plug(Tesla.Middleware.Headers, [{"User-Agent", "#{@app}/#{@version}"}])
  plug(Tesla.Middleware.DecodeJson)
  unless Mix.env() == :test, do: plug(Tesla.Middleware.Logger)
  plug(Tesla.Middleware.Timeout, timeout: 10_000)
  plug(Marvel.Middleware.Tracing)
  plug(Marvel.Middleware.Cache)
  plug(Marvel.Middleware.Auth)

  @doc """
  For any resources that returns a collection that is more than 100 (enforced limit)
  """
  def get_all(url, limit \\ 100) do
    initial_response = get!(url, query: [limit: 1])
    total = initial_response.body["data"]["total"]

    # make a list of 1 to the returned total every n numbers defined by `limit`
    :lists.seq(1, total, limit)
    |> Enum.map(fn offset ->
      Task.async(fn ->
        # make a request to the same url just changing the offset, given to us by the parent map function
        get(url, query: [limit: limit, offset: offset])
      end)
    end)
    |> Enum.map(&Task.await(&1, 10_000))
    |> Enum.concat([{:ok, initial_response}])
    # beacuse data.results returns an array of values we want to flatten that, hence the use of `Enum.flat_map/2`
    # we can also assume that everything worked and didn't error
    # TODO: error handling
    |> Enum.flat_map(fn {:ok, resp} -> resp.body["data"]["results"] end)
  end
end

defmodule Marvel do
  @moduledoc """
  Marvel API Wrapper
  Uses Tesla to make requests with special middleware to satisfy marvel auth
  and uses Cachex to cache the calls for greater response times.
  """
  use Tesla
  @version Mix.Project.config()[:version]
  @app Application.get_env(:marvel, :client_name)

  adapter Tesla.Adapter.Hackney, recv_timeout: :infinity, connect_timeout: 50_000

  # we want to be able to not request the actual api while testing
  unless Mix.env() == :test,
    do: plug(Tesla.Middleware.BaseUrl, "https://gateway.marvel.com/v1/public")

  # the order is very important here because of the way the middleware is evaluated
  # first we set the user agent headers because we want to be a nice internet citizen
  plug(Tesla.Middleware.Headers, [{"User-Agent", "#{@app}/#{@version}"}])
  # if the request fails we should try again
  plug(Marvel.Middleware.ExponentialRetry)
  # then since we want to deal with json immedieately we parse and decode asap
  plug(Tesla.Middleware.DecodeJson)
  # put some extra instrumentation
  plug(Marvel.Middleware.Tracing)
  # we want to reuse responses as much as possible to limit api use
  plug(Marvel.Middleware.Cache)
  # finally we attach the required authentication query params
  plug(Marvel.Middleware.Auth)
  # and then we log it last because we only want to log actual http requests
  unless Mix.env() == :test, do: plug(Tesla.Middleware.Logger)

  @doc """
  For any resources that returns a collection that is more than 100 (enforced limit)
  """
  def get_all(url, limit \\ 100) do
    # TODO: error handling
    first_response = get!(url, query: [limit: limit])
    total = first_response.body["data"]["total"]

    if total > limit do
      # make a list of 1 to the returned total every n numbers defined by `limit`
      # credo:disable-for-next-line Credo.Check.Refactor.PipeChainStart
      :lists.seq(limit, total, limit)
      |> Enum.map(fn offset ->
        Task.async(fn ->
          # make a request to the same url just changing the offset, given to us by the parent map function
          get(url, query: [limit: limit, offset: offset])
        end)
      end)
      |> Enum.map(&Task.await(&1, :infinity))
      |> Enum.concat([{:ok, first_response}])
      # beacuse data.results returns an array of values we want to flatten that, hence the use of `Enum.flat_map/2`
      # we can also assume that everything worked and didn't error
      |> Enum.flat_map(fn {:ok, resp} -> get_results(resp) end)
    else
      get_results(first_response)
    end
  end

  defp get_results(response) do
    get_in(response.body, ["data", "results"])
  end
end

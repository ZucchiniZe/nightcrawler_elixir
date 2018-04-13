defmodule Nightcrawler.Application do
  @moduledoc """
  The start/supervisor file for the entire application
  """

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      # Start the Ecto repository
      supervisor(Nightcrawler.Repo, []),
      # Start the endpoint when the application starts
      supervisor(NightcrawlerWeb.Endpoint, []),
      worker(Cachex, [:marvel_cache, [stats: true]], id: :marvel_cache),
    ]

    opts = [strategy: :one_for_one, name: Nightcrawler.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    NightcrawlerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule Nightcrawler.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    cachex_options = []

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Nightcrawler.Repo, []),
      # Start the endpoint when the application starts
      supervisor(NightcrawlerWeb.Endpoint, []),
      # Start your own worker by calling: Nightcrawler.Worker.start_link(arg1, arg2, arg3)
      # worker(Nightcrawler.Worker, [arg1, arg2, arg3]),
      worker(Cachex, [:characters, cachex_options], id: :characters_cache),
      worker(Cachex, [:comics, cachex_options], id: :comics_cache),
      worker(Cachex, [:creators, cachex_options], id: :creators_cache),
      worker(Cachex, [:events, cachex_options], id: :events_cache),
      worker(Cachex, [:series, cachex_options], id: :series_cache),
      worker(Cachex, [:stories, cachex_options], id: :stories_cache),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Nightcrawler.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    NightcrawlerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

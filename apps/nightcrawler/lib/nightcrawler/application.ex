defmodule Nightcrawler.Application do
  @moduledoc """
  The Nightcrawler Application Service.

  The nightcrawler system business domain lives in this application.

  Exposes API to clients such as the `NightcrawlerWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(Nightcrawler.Repo, []),
    ], strategy: :one_for_one, name: Nightcrawler.Supervisor)
  end
end

defmodule Marvel.Application do
  @moduledoc """
  The supervisor for the marvel cache.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      worker(Cachex, [:marvel_cache, [stats: true]], id: :marvel_cache)
    ], strategy: :one_for_one, name: Marvel.Supervisor)
  end
end
defmodule Marvel.MixProject do
  use Mix.Project

  def project do
    [
      app: :marvel,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Marvel.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:scout_apm, "~> 0.4.1"},
      {:tesla, "~> 1.0.0-beta.1"},
      {:jason, ">= 1.0.0"},
      {:cachex, "~> 3.0"},
    ]
  end
end

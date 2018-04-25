defmodule Nightcrawler.Umbrella.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp deps do
    [{:credo, "~> 0.9.0-rc1", only: [:dev, :test], runtime: false}]
  end
end

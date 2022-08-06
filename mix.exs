defmodule AdventOfCodeEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :aoc_ex,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: ["test.aoc": :test, "test.aoc.grid": :test],
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :crypto]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:checkov, "~> 1.0.0", only: :test},
      {:libgraph, "~> 0.13.3"},
      {:benchee, "~> 1.1"},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
      {:httpoison, "~> 1.8"},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end

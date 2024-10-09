defmodule Chronus.MixProject do
  use Mix.Project

  def project do
    [
      app: :chronus,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      consolidate_protocols: Mix.env() == :prod
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      # <--- This line specifies the module to start
      mod: {Chronus.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:amqp, "~> 3.3"},
      {:jason, "~> 1.2"},
      {:bandit, "~> 1.0"}
    ]
  end
end

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

  def application do
    [
      extra_applications: [:logger, :prometheus_ex],
      mod: {Chronus.Application, []}
    ]
  end

  defp deps do
    [
      {:amqp, "~> 3.3"},
      {:jason, "~> 1.2"},
      {:bandit, "~> 1.0"},
      {:prometheus_ex, "~> 3.0"},
      {:prometheus_plugs, "~> 1.1"}
    ]
  end
end

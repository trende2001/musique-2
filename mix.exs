defmodule Musique.MixProject do
  use Mix.Project

  def project do
    [
      app: :bot,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: dialyzer()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Musique.Core.App, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.7.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:exyt_dlp, "~> 0.1.2"},
      {:nostrum, "~> 0.10", override: true},
      {:decimal, "~> 2.1"},
      {:nosedrum, git: "https://github.com/jchristgit/nosedrum"}
    ]
  end

  defp dialyzer do
    [
      plt_core_path: "priv/plts/",
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
    ]
  end
end

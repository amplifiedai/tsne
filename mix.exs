defmodule Tsne.MixProject do
  use Mix.Project

  @source_url "https://github.com/amplifiedai/tsne"
  @version "0.2.0-dev"

  def project do
    [
      app: :tsne,
      name: "t-SNE",
      description: "Bindings to efficient exact and Barnes-Hut t-SNE for Elixir",
      version: @version,
      elixir: "~> 1.14",
      package: package(),
      deps: deps(),
      docs: docs(),
      preferred_cli_env: [
        docs: :docs,
        "hex.publish": :docs
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.29", only: :docs, runtime: false},
      {:nimble_options, "~> 0.3.0"},
      {:rustler, ">= 0.0.0", optional: true},
      {:rustler_precompiled, "~> 0.6"}
    ]
  end

  defp docs do
    [
      main: "Tsne",
      source_ref: "v#{@version}",
      source_url: @source_url,
      extras: ["LICENSE", "notebooks/dimensionality_reduction.livemd"]
    ]
  end

  defp package do
    [
      files: [
        "lib",
        "native",
        "checksum-*.exs",
        "mix.exs",
        "LICENSE"
      ],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url},
      maintainers: ["Christopher Grainger"]
    ]
  end
end

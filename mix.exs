defmodule Cldr.Utils.MixProject do
  use Mix.Project

  @version "2.14.0"

  def project do
    [
      app: :cldr_utils,
      version: @version,
      elixir: "~> 1.6",
      description: description(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      source_url: "https://github.com/elixir-cldr/cldr_utils",
      test_coverage: [tool: ExCoveralls],
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env()),
      dialyzer: [
        ignore_warnings: ".dialyzer_ignore_warnings",
        plt_add_apps: ~w(inets decimal)a
      ],
      compilers: Mix.compilers()
    ]
  end

  defp description do
    """
    Map, Calendar, Digits, Decimal, HTTP, Macro, Math and String helpers for ex_cldr
    """
  end

  def application do
    [
      extra_applications: [:logger, :inets, :ssl]
    ]
  end

  defp deps do
    [
      {:decimal, "~> 1.6 or ~> 2.0"},
      {:castore, "~> 0.1", optional: true},
      {:certifi, "~> 2.5", optional: true},
      {:ex_doc, "~> 0.18", only: [:release, :dev]},
      {:stream_data, "~> 0.4", only: :test},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:benchee, "~> 1.0", only: [:dev], runtime: false, optional: true}
    ]
  end

  defp package do
    [
      maintainers: ["Kip Cole"],
      licenses: ["Apache 2.0"],
      links: links(),
      files: [
        "lib",
        "config",
        "mix.exs",
        "README*",
        "CHANGELOG*",
        "LICENSE*"
      ]
    ]
  end

  def links do
    %{
      "GitHub" => "https://github.com/elixir-cldr/cldr_utils",
      "Readme" => "https://github.com/elixir-cldr/cldr_utils/blob/v#{@version}/README.md",
      "Changelog" => "https://github.com/elixir-cldr/cldr_utils/blob/v#{@version}/CHANGELOG.md"
    }
  end

  def docs do
    [
      source_ref: "v#{@version}",
      main: "readme",
      extras: [
        "README.md",
        "LICENSE.md",
        "CHANGELOG.md"
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "mix", "test"]
  defp elixirc_paths(:dev), do: ["lib", "mix", "benchee"]
  defp elixirc_paths(_), do: ["lib"]

  def aliases do
    []
  end
end

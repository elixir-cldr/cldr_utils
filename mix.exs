defmodule CldrUtils.MixProject do
  use Mix.Project

  @version "2.0.5"

  def project do
    [
      app: :cldr_utils,
      version: @version,
      elixir: "~> 1.5",
      description: description(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      source_url: "https://github.com/kipcole9/cldr_utils",
      test_coverage: [tool: ExCoveralls],
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env()),
      dialyzer: [
        ignore_warnings: ".dialyzer_ignore_warnings",
        plt_add_apps: ~w(gettext inets jason mix poison plug)a
      ],
      compilers: Mix.compilers()
    ]
  end

  defp description do
    """
    Map, Calendar, Digits, Macro, Math and String helpers for ex_cldr
    """
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:decimal, "~> 1.5"},
      {:ex_doc, "~> 0.18", only: [:release, :dev]},
      {:stream_data, "~> 0.4", only: :test}
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
      "GitHub" => "https://github.com/kipcole9/cldr_utils",
      "Readme" => "https://github.com/kipcole9/cldr_utils/blob/v#{@version}/README.md",
      "Changelog" => "https://github.com/kipcole9/cldr_utils/blob/v#{@version}/CHANGELOG.md"
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
  defp elixirc_paths(:dev), do: ["lib", "mix", "bench"]
  defp elixirc_paths(_), do: ["lib"]

  def aliases do
    []
  end
end

defmodule Elevio.MixProject do
  use Mix.Project

  def project do
    [
      app: :elevio,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      escript: escript()
    ]
  end

  defp escript do
    [main_module: Elevio]
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
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:httpoison, "~> 1.4"},
      {:poison, "~> 3.1"},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end
end

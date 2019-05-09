defmodule ImboConnector.MixProject do
  use Mix.Project

  def project do
    [
      app: :imbo_connector,
      version: "0.2.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description()
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
      {:httpoison, "~> 1.4"},
      {:timex, "~> 3.1"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs"],
      maintainers: ["Petter Kaspersen"],
      licenses: ["MIT"],
      links: %{}
    ]
  end

  defp description do
    """
    Helps you connect and work with Imbo
    """
  end
end

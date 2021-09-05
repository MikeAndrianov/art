defmodule Art.MixProject do
  use Mix.Project

  def project do
    [
      app: :art,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Art.Application, []}
    ]
  end

  defp deps do
    [
      {:plug_cowboy, "~> 2.5"},
      {:ecto, "~> 3.7.1"},
      {:jason, "~> 1.2"}
    ]
  end
end

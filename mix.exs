defmodule Servo.MixProject do
  use Mix.Project

  def project do
    [
      app: :servo,
      version: "0.1.0",
      elixir: "~> 1.12",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "Tom Servo",
      source_url: "https://github.com/atparkweb/tom-servo"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :eex]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      { :ex_doc, "~> 0.24", only: :dev, runtime: false },
      { :poison, "~> 5.0" },
      { :httpoison, "~> 1.8" },
      { :earmark, "~> 1.4" }
    ]
  end

  defp description do
    "An example of a simple HTTP server built from scratch with Elixir."
  end

  defp package do
    [
      name: "atparkweb_servo",
      licenses: ["Apache-2.0"],
      links: %{ "Github" => "https://github.com/atparkweb/tom-servo"}
    ]
  end
end

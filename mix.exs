defmodule Bender.MixProject do
  use Mix.Project

  def project do
    [
      app: :bender,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :inets],
      mod: {Bender.Application, []},

      # Put the server address here
      env: [server_url: "http://localhost:8080/"]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:libgraph, ">= 0.16.0"},
      {:jason, "~> 1.4"}

    ]
  end
end

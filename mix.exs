defmodule WhatsNext.Mixfile do
  use Mix.Project

  def project do
    [app: :whats_next,
     version: "0.0.1",
     elixir: "~> 0.15.0",
     deps: deps,
     escript: escript]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :httpotion]]
  end

  # Dependencies can be hex.pm packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      { :httpotion, "~> 0.2.4", github: "myfreeweb/httpotion"},
      { :json, "~> 0.3.0" }
    ]
  end

  defp escript do
    [main_module: WhatsNext.CLI]
  end
end

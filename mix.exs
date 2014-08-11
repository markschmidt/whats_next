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
      { :httpotion, "~> 0.2.4", github: "myfreeweb/httpotion", override: true },
      { :json, "~> 0.3.0" },
      { :exvcr, "~> 0.3.1", github: "parroty/exvcr" },
      { :mock, "~> 0.0.4", github: "jjh42/mock" },
      { :meck, "0.8.2", github: "eproxus/meck", override: true }
    ]
  end

  defp escript do
    [main_module: WhatsNext.CLI]
  end
end

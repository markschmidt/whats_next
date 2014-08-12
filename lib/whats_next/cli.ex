defmodule WhatsNext.CLI do

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean],
                                     aliases:  [ h:    :help   ])
    case parse do
      { [ help: true ], _ }       -> :help
      { _, [series, episode], _ } -> { series, episode }
      _                           -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: whats_next <series> <episode_number>
    """
    System.halt(0)
  end

  def process({series, episode}) do
    series
    |> WhatsNext.DataFetcher.fetch
    |> WhatsNext.Decoder.decode
    |> WhatsNext.Episode.next_air_date(episode)
    |> print_result(series)
  end

  defp print_result(date, series), do: IO.puts "#{series}: #{date}"

end

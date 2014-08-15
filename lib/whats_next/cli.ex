defmodule WhatsNext.CLI do

  def main(argv) do
    argv
    |> parse_args
    |> process
    |> print_results
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean],
                                     aliases:  [ h:    :help   ])
    case parse do
      { [ help: true ], _ }       -> :help
      { _, [series, episode], _ } -> { series, episode }
      { _, [], _ }                -> Enum.to_list(IO.stream(:stdio, :line))
      _                           -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: whats_next <series> <episode_number>
    """
    System.halt(0)
  end

  def process(list) when is_list(list) do
    list |> Enum.map(fn(input) ->
      [series, episode] = String.split(input, ":") |> Enum.map(&String.strip(&1))
      process {series, episode}
    end)
  end

  def process({series, episode}) do
    date = series
           |> WhatsNext.DataFetcher.fetch
           |> WhatsNext.Decoder.decode
           |> WhatsNext.Episode.next_air_date(episode)

    {series, date}
  end

  def print_results({series, date}), do: IO.puts "#{series}: #{date}"
  def print_results(list) when is_list(list) do
    Enum.each(list, fn(x) -> print_results(x) end)
  end

end

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
    input_list = list |> Enum.map(&parse_input_line(&1))

    spawn_link(WhatsNext.Spawner, :spawn_processes, [input_list, self()])
    receive do
      {:ok, result_list} ->
        result_list
    end
  end
  def process(entry), do: process([entry]) |> hd

  def print_results({series, date}), do: IO.puts "#{series}: #{date}"
  def print_results(list) when is_list(list) do
    Enum.each(list, fn(x) -> print_results(x) end)
  end

  defp parse_input_line(input) when is_binary(input) do
    String.split(input, ":")
    |> Enum.map(&String.strip(&1))
    |> List.to_tuple
  end
  defp parse_input_line(input) when is_tuple(input), do: input

end

defmodule WhatsNext.Spawner do

  def spawn_processes(list, caller) do
    Process.flag(:trap_exit, true)

    orderd_pids = Enum.map(list, &spawn_link(WhatsNext.Spawner, :process, [&1, self()]))

    result_list = receive_data(length(list), []) |> sort(orderd_pids)
    send caller, {:ok, result_list}
  end

  defp sort(result_list, pids) do
    result_list
    |> Enum.sort(fn({x,_,_},{y,_,_}) -> before_in_list(pids, x, y) end)
    |> Enum.map(&Tuple.delete_at(&1, 0))
  end

  defp before_in_list(pids, x, y) do
    Enum.find_index(pids, &(&1 == x)) < Enum.find_index(pids, &(&1 == y))
  end

  def receive_data(count, result_list) when count == 0, do: result_list
  def receive_data(count, result_list) when count > 0 do
    receive do
      {:ok, pid, series, date} ->
        receive_data(count - 1, [{pid, series, date} | result_list])
      {:EXIT, _, :normal} ->
        receive_data(count, result_list)
      {:EXIT, _, _} ->
        receive_data(count - 1, result_list)
    after
      5_000 ->
        IO.puts "timed out"
        result_list
    end
  end


  def process({series, episode}, caller) do
    date = series
           |> WhatsNext.DataFetcher.fetch
           |> WhatsNext.Decoder.decode
           |> WhatsNext.Episode.next_air_date(episode)

    send caller, {:ok, self(), series, date}
  end


end

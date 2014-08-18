defmodule WhatsNext.Episode do

  def next_air_date(list, episode), do: do_next_air_date(list, episode)

  defp do_next_air_date([current, next | tail], episode) do
    if same_episode?(current, episode), do: Enum.at(next, 1),
    else: do_next_air_date([next|tail], episode)
  end
  defp do_next_air_date([_], _), do: nil


  defp same_episode?([episode1, _], episode2) do
    remove_leading_zero(episode1) == remove_leading_zero(episode2)
  end

  defp remove_leading_zero(<<head :: integer, tail :: binary>>) when head == 48, do: tail
  defp remove_leading_zero(str), do: str

end

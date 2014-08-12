defmodule WhatsNext.Episode do

  def next_air_date(list, episode) do
    index = Enum.find_index(list, &same_episode?(hd(&1), episode))
    case index do
      nil -> nil
      _   -> Enum.at(list, index + 1) |> Enum.at(1)
    end
  end

  defp same_episode?(str1, str2) do
    remove_leading_zero(str1) == remove_leading_zero(str2)
  end

  defp remove_leading_zero(<<head :: integer, tail :: binary>>) when head == 48, do: tail
  defp remove_leading_zero(str), do: str

end

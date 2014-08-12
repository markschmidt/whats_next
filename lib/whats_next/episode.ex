defmodule WhatsNext.Episode do

  def next_air_date(list, episode) do
    index = Enum.find_index(list, fn(x) -> hd(x) == episode end)
    case index do
      nil -> nil
      _   -> Enum.at(list, index + 1) |> Enum.at(1)
    end
  end

end

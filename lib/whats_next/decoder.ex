defmodule WhatsNext.Decoder do

  def decode(data, episode) do
    data
    |> find_next_episode(episode)
    |> format_date
  end

  def find_next_episode({:ok, body}, episode) do
    episode = convert_episode(episode)
    case Regex.run(~r/^.*#{episode}.*(\d\d\/.+\/\d\d).*<a/rim, body) do
      [_, tail] -> {:ok, tail}
      nil       -> {:error}
    end
  end
  def find_next_episode({:error, body}, _) do
    IO.puts :stderr, "Error: #{body}"
    {:error}
  end

  def convert_episode(episode) do
    episode |> String.replace("x", "-") |> remove_leading_zero
  end

  def remove_leading_zero(<<head :: integer, tail :: binary>>) when head == 48, do: tail
  def remove_leading_zero(str), do: str

  def format_date({:error}), do: nil
  def format_date({:ok, string}) do
    # 06/Jan/11
    [day, month, year] = String.split(string, "/")
    full_year(String.to_integer(year)) <> "-" <> month_to_i(month) <> "-" <> day
  end

  def full_year(year) when year < 20, do: "20#{year}"

  def month_to_i(month) do
    months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    number = Enum.find_index(months, fn(x) -> x == month end) + 1
    if number <= 9 do
      "0#{number}"
    else
      "#{number}"
    end
  end

end

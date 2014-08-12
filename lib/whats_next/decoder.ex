defmodule WhatsNext.Decoder do

  def decode({:ok, raw_epguide_page}) do
    raw_epguide_page
    |> find_episodes
    |> Enum.map(&normalize_entry(&1))
  end

  defp find_episodes(raw_page) do
    Regex.scan(~r/^.*(\d?\d\-\d\d).*(\d\d\/.+\/\d\d).*<a/rim, raw_page)
    |> Enum.map(fn(x) -> tl(x) end)
  end

  defp normalize_entry([episode, date]) do
    [String.replace(episode, "-", "x"), format_date(date)]
  end

  def format_date(string) do
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

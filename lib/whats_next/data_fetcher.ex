defmodule WhatsNext.DataFetcher do

  alias HTTPotion.Response

  def fetch(series) do
    series
    |> correct_series_name
    |> fetch_series_id
    |> decode_json
    |> extract_series_url
    |> fetch_data
  end

  def correct_series_name("Utopia"), do: "Utopia -2014"
  def correct_series_name(name), do: name

  defp fetch_series_id(series) do
    query = "allintitle: site:epguides.com " <> series
    url = "http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=" <> URI.encode(query)
    fetch_data(url)
  end

  defp decode_json({:ok, body}), do: JSON.decode(body)
  defp decode_json({:error, msg}) do
    error = JSON.decode(msg)["message"]
    IO.puts "Error fetching from series name: #{error}"
    System.halt(2)
  end

  defp extract_series_url({:ok, response}) do
    (response["responseData"]["results"] |> hd)["unescapedUrl"]
  end

  defp fetch_data(url) do
    case HTTPotion.get(url, [], [timeout: 10000]) do
      %Response{body: body, status_code: status, headers: _headers }
      when status in 200..299 ->
        { :ok, body }
      %Response{body: body, status_code: _status, headers: _headers } ->
        { :error, body }
    end
  end

end

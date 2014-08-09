defmodule WhatsNext.DataFetcher do

  alias HTTPotion.Response

  def fetch(series) do
    series
    |> fetch_series_id
    |> decode_response
    |> extract_series_url
    |> fetch_episode_data
  end

  defp fetch_series_id(series) do
    query = "allintitle: site:epguides.com " <> series
    url = "http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=" <> URI.encode(query)
    case HTTPotion.get(url) do
      %Response{body: body, status_code: status, headers: _headers }
      when status in 200..299 ->
        { :ok, body }
      %Response{body: body, status_code: _status, headers: _headers } ->
        { :error, body }
    end
  end

  defp decode_response({:ok, body}), do: JSON.decode(body)
  defp decode_response({:error, msg}) do
    error = JSON.decode(msg)["message"]
    IO.puts "Error fetching from series name: #{error}"
    System.halt(2)
  end

  defp extract_series_url({:ok, response}) do
    (response["responseData"]["results"] |> hd)["unescapedUrl"]
  end

  defp fetch_episode_data(series_url) do
    case HTTPotion.get(series_url) do
      %Response{body: body, status_code: status, headers: _headers }
      when status in 200..299 ->
        { :ok, body }
      %Response{body: body, status_code: _status, headers: headers } ->
        IO.puts headers[:location]
        { :error, body }
    end
  end

end

defmodule WhatsNext.DataFetcher do

  import WhatsNext.FileCache, only: [cache: 2]
  alias HTTPotion.Response

  def fetch(series) do
    series
    |> correct_series_name
    |> fetch_epguides_url
    |> fetch_epguides_data(series)
  end

  def correct_series_name("Utopia"), do: "Utopia -2014"
  def correct_series_name(name), do: name

  defp fetch_epguides_url(series) do
    cache(cache_file(:id, series), fn() ->
      fetch_epguides_url(series, :without_cache)
    end)
  end

  defp fetch_epguides_url(series, :without_cache) do
    series
    |> fetch_series_id
    |> decode_json
    |> extract_series_url
  end

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

  defp extract_series_url({:ok, %{"responseData"=>%{"results"=>results}}}) when length(results) > 0 do
    (results |> hd)["unescapedUrl"]
  end
  defp extract_series_url({:ok, _}), do: nil

  defp fetch_epguides_data(nil, series) do
    IO.puts "Could not fetch url for #{series}"
    {:error}
  end
  defp fetch_epguides_data(url, series) do
    cache(cache_file(:data, series), fn() -> fetch_data(url) end)
    |> ensure_tuple
  end

  defp fetch_data(url) do
    case HTTPotion.get(url, [], [timeout: 10000]) do
      %Response{body: body, status_code: status, headers: _headers }
      when status in 200..299 ->
        { :ok, body }
      %Response{body: _body, status_code: _status, headers: _headers } ->
        { :error }
    end
  end

  defp cache_file(:id, series), do: "#{System.user_home}/.cache/whats_next/epguides_ids/#{series}"
  defp cache_file(:data, series), do: "#{System.user_home}/.cache/whats_next/epguides_data/#{series}"

  defp ensure_tuple(data) when is_tuple(data), do: data
  defp ensure_tuple(data), do: {:ok, data}
end

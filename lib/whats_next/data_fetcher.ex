defmodule WhatsNext.DataFetcher do

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
    case File.read(cache_file(series)) do
      {:ok, body} -> body |> String.strip
      _           -> fetch_epguides_url(series, :refresh_cache)
    end
  end

  defp fetch_epguides_url(series, :refresh_cache) do
    series
    |> fetch_series_id
    |> decode_json
    |> extract_series_url
    |> write_to_cache(series)
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

  defp extract_series_url({:ok, response}) do
    (response["responseData"]["results"] |> hd)["unescapedUrl"]
  end

  defp write_to_cache(url, series) do
    unless File.exists?(cache_folder), do: File.mkdir_p(cache_folder)
    case File.write(cache_file(series), url <> "\n") do
      :ok -> nil
      {:error, reason} -> IO.puts "Could not write cache-file: #{reason}"
    end
    url
  end

  defp write_to_data_cache({:ok, data}, series) do
    unless File.exists?(cache_folder_data), do: File.mkdir_p(cache_folder_data)
    case File.write(cache_file_data(series), data <> "\n") do
      :ok -> nil
      {:error, reason} -> IO.puts "Could not write cache-file: #{reason}"
    end
    {:ok, data}
  end
  defp write_to_data_cache(response, series), do: response

  defp cache_folder, do: "#{System.user_home}/.cache/whats_next/epguides_ids"
  defp cache_file(series), do: Path.join([cache_folder, series])

  defp cache_folder_data, do: "#{System.user_home}/.cache/whats_next/epguides_data"
  defp cache_file_data(series), do: Path.join([cache_folder_data, series])

  def fetch_epguides_data(url, series) do
    case File.read(cache_file_data(series)) do
      {:ok, body} -> {:ok, body}
      _           -> fetch_data(url) |> write_to_data_cache(series)
    end
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

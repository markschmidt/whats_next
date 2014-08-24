defmodule WhatsNext.FileCache do

  def cache(filename, data_function) do
    case File.read(filename) do
      {:ok, body} -> body |> String.strip
      _           -> data_function.() |> write_to_cache(filename)
    end
  end

  defp write_to_cache({:ok, data}, filename), do: {:ok, write_to_cache(data,filename)}
  defp write_to_cache({:error, data}, filename), do: {:error, data}
  defp write_to_cache(nil, _filename), do: nil
  defp write_to_cache(data, filename) do
    Path.dirname(filename) |> ensure_folder_exists
    case File.write(filename, data <> "\n") do
      :ok -> nil
      {:error, reason} -> IO.puts "Could not write to file cache '#{filename}': #{reason}"
    end
    data
  end

  defp ensure_folder_exists(folder) do
    unless File.exists?(folder), do: File.mkdir_p(folder)
  end
end

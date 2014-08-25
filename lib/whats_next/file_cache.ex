defmodule WhatsNext.FileCache do

  alias WhatsNext.Setting

  def cache(filename, data_function) do
    do_cache(filename, data_function, Setting.get(:file_caching))
  end

  defp do_cache(filename, data_function, true) do
    case File.read(filename) do
      {:ok, body} -> body |> String.strip
      _           -> data_function.() |> write_to_cache(filename)
    end
  end
  defp do_cache(_filename, data_function, false), do: data_function.()

  defp write_to_cache({:ok, data}, filename), do: {:ok, write_to_cache(data,filename)}
  defp write_to_cache({:error, data}, _filename), do: {:error, data}
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

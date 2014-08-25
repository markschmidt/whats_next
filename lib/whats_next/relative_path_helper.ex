defmodule WhatsNext.RelativePathHelper do

  def traverse(path, url) do
    [_, domain, prev_path] = Regex.run(~r/\A(https?:\/\/.+)(\/.*)\/?\z/rim, url)

    case path do
      "http" <> _rest -> path
      "/"    <> _rest -> domain <> path
      _ ->
        new_path = traverse_relative(path, String.split(prev_path, "/") |> Enum.reverse)
        domain <> new_path
    end
  end

  defp traverse_relative("../" <> tail, url_segments) when is_list(url_segments) and length(url_segments) > 1 do
    traverse_relative(tail, url_segments |> tl)
  end

  defp traverse_relative(path, url_segments) do
    url = Enum.reverse(url_segments) |> Enum.join("/")
    url <> "/" <> path
  end
end

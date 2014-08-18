defmodule WhatsNext.FileCacheTest do
  use ExUnit.Case, async: false

  import WhatsNext.FileCache

  @tmp_dir "test/fixtures/tmp"
  @cache_file Path.join([@tmp_dir, "foobar"])

  setup do
    clean_tmp_dir
    on_exit(nil, fn() -> clean_tmp_dir end)
    :ok
  end

  test "should create file with the given name and value of the function" do
    cache(@cache_file, fn() -> "some data" end)

    assert true == File.exists?(@cache_file)
    assert "some data\n" == File.read!(@cache_file)
  end

  test "should read existing cache file" do
    File.write!(@cache_file, "cached content\n")

    assert "cached content", cache(@cache_file, nil)
  end

  test "should cache content if function returns tuple with ok" do
    cache(@cache_file, fn() -> {:ok, "some data"} end)

    assert true == File.exists?(@cache_file)
    assert "some data\n" == File.read!(@cache_file)
  end

  test "should not cache content if function returns tuple with error" do
    cache(@cache_file, fn() -> {:error, "some data"} end)

    assert false == File.exists?(@cache_file)
  end


  defp clean_tmp_dir() do
    Path.wildcard(Path.join([@tmp_dir, "*"]))
    |> Enum.each(&File.rm(&1))
  end

end

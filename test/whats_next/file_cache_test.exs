defmodule WhatsNext.FileCacheTest do
  use ExUnit.Case

  import WhatsNext.FileCache
  alias WhatsNext.Setting

  @tmp_dir "test/fixtures/tmp"
  @cache_file Path.join([@tmp_dir, "foobar"])

  setup do
    clean_tmp_dir
    Setting.set(:file_caching, true)
    on_exit(nil, fn() -> clean_tmp_dir end)
    :ok
  end

  test "should create file with the given name and value of the function" do
    cache(@cache_file, fn() -> "some data" end)

    assert true == File.exists?(@cache_file)
    assert "some data\n" == File.read!(@cache_file)
  end

  test "should not create file if file_caching is disabled" do
    Setting.set(:file_caching, false)
    cache(@cache_file, fn() -> "some data" end)

    assert false == File.exists?(@cache_file)
  end

  test "should read existing cache file" do
    File.write!(@cache_file, "cached content\n")

    assert "cached content", cache(@cache_file, nil)
  end

  test "should not read existing cache file if file_caching is disabled" do
    Setting.set(:file_caching, false)
    File.write!(@cache_file, "cached content\n")

    assert "not cached", cache(@cache_file, fn() -> "not cached" end)
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

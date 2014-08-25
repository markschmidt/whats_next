defmodule WhatsNext.RelativePathHelperTest do
  use ExUnit.Case

  import WhatsNext.RelativePathHelper

  [
    {"../test2",     "http://foobar.com/test/", "http://foobar.com/test2"},
    {"../test2",     "http://foobar.com/test", "http://foobar.com/test2"},
    {"../test2",     "http://foobar.com/test/test", "http://foobar.com/test/test2"},
    {"../../test2",  "http://foobar.com/test/test", "http://foobar.com/test2"},
    {"../../test2",  "http://foobar.com/test", "http://foobar.com/../test2"},
    {"/test2",       "http://foobar.com/test", "http://foobar.com/test2"},
    {"http://test2", "http://foobar.com/test", "http://test2"}
  ] |> Enum.each(fn({path,url,result}) ->
    test "traverse #{url} with #{path} should result in #{result}" do
      assert unquote(result) == traverse(unquote(path), unquote(url))
    end
  end)

end

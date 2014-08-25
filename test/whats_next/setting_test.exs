defmodule WhatsNext.SettingTest do
  use ExUnit.Case

  import WhatsNext.Setting

  test "should have a default value for :file_caching" do
    assert true == get(:file_caching)
  end

  test "should set a value for :file_caching" do
    set(:file_caching, false)
    assert false == get(:file_caching)
  end

end

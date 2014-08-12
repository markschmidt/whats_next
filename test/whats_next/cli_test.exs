defmodule WhatsNext.CLITest do
  use ExUnit.Case, async: false
  use ExVCR.Mock

  import Mock
  import WhatsNext.CLI

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes")
    :ok
  end

  test "#parse_args should detect series and episode as arguments" do
    assert {"Suits", "3x12"} == parse_args(["Suits", "3x12"])
  end

  test_with_mock "should print airdate for given input", IO, [:passthrough], [puts: fn(_str) -> nil end] do
    use_cassette "requests_for_suits" do
      process({"Suits", "3x11"})
      assert called IO.puts "Suits: 2014-03-13"
    end
  end

end

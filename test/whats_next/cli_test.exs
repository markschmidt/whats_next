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

  test_with_mock "should print airdate for Utopia regression", IO, [:passthrough], [puts: fn(_str) -> nil end] do
    use_cassette "requests_for_utopia" do
      process({"Utopia", "2x05"})
      assert called IO.puts "Utopia: 2014-08-12"
    end
  end

  test_with_mock "should print airdate for input from stdin", IO, [:passthrough], [puts: fn(_str) -> nil end] do
    use_cassette "requests_for_suits" do
      process(["Suits: 3x02", "Suits: 3x03", "Suits: 3x04"])
      assert called IO.puts "Suits: 2013-07-30"
      assert called IO.puts "Suits: 2013-08-06"
      assert called IO.puts "Suits: 2013-08-13"
    end
  end

end

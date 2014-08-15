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

  test "should return airdate for given input" do
    use_cassette "requests_for_suits" do
      assert {"Suits", "2014-03-13"} == process({"Suits", "3x11"})
    end
  end

  test "should return airdate for Utopia regression" do
    use_cassette "requests_for_utopia" do
      assert {"Utopia", "2014-08-12"} == process({"Utopia", "2x05"})
    end
  end

  test "should return multiple airdates for input list" do
    use_cassette "requests_for_suits" do
      expected = [{"Suits", "2013-07-30"},{"Suits", "2013-08-06"},{"Suits", "2013-08-13"}]

      assert expected == process(["Suits: 3x02", "Suits: 3x03", "Suits: 3x04"])
    end
  end

  test_with_mock "should print results", IO, [:passthrough], [puts: fn(_str) -> nil end] do
    print_results([{"Suits", "2013-07-30"},{"Suits", "2013-08-06"},{"Suits", "2013-08-13"}])
    assert called IO.puts "Suits: 2013-07-30"
    assert called IO.puts "Suits: 2013-08-06"
    assert called IO.puts "Suits: 2013-08-13"
  end

end

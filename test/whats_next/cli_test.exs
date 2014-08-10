defmodule WhatsNext.CLITest do
  use ExUnit.Case, async: false

  import Mock
  import WhatsNext.CLI
  import MockingHelper

  test "#parse_args should detect series and episode as arguments" do
    assert {"Suits", "3x12"} == parse_args(["Suits", "3x12"])
  end

  #TODO: mock web requests here as well?
  test_with_mock "should print airdate for given input", IO, [puts: fn(_str) -> nil end] do
    with_mock HTTPotion, http_mock_options do
      process({"Suits", "3x12"})
      assert called IO.puts "Suits: 2014-03-13"
    end
  end

end

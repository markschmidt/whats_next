defmodule WhatsNext.DecoderTest do
  use ExUnit.Case

  import WhatsNext.Decoder
  import MockingHelper

  test "should find airdate for given episode" do
    assert "2014-03-13" == decode(epguides_data, "3x12")
  end

  defp epguides_data do
    {:ok, epguides_response}
  end
end

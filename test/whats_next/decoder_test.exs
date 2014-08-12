defmodule WhatsNext.DecoderTest do
  use ExUnit.Case

  import WhatsNext.Decoder
  import MockingHelper

  test "#decode should return a list of episodes" do
    result = decode(epguides_data)
    assert ["1x01", "2011-06-23"] == Enum.at(result, 0)
    assert ["4x07", "2014-07-30"] == Enum.at(result, 50)
  end

  defp epguides_data do
    {:ok, epguides_response}
  end
end

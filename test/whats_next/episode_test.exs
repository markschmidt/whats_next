defmodule WhatsNext.EpisodeTest do
  use ExUnit.Case

  import WhatsNext.Episode

  @example_list [["1x01", "2011-06-23"], ["1x02", "2011-06-30"], ["1x03", "2011-07-07"]]

  test "#next_air_date should return next entry in list" do
    assert "2011-06-30" == next_air_date(@example_list, "1x01")
  end

  test "#next_air_date should ignore leading zeros" do
    assert "2011-06-30" == next_air_date(@example_list, "01x01")
    assert "2011-06-30" == next_air_date([["01x01", "2011-06-23"], ["01x02", "2011-06-30"]], "1x01")
  end

  test "#next_air_date should return nil if the last index is given" do
    assert nil == next_air_date(@example_list, "01x03")
  end

  test "#next_air_date should return nil if there is no next entry" do
    assert nil == next_air_date(@example_list, "20x01")
  end

end

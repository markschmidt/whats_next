defmodule WhatsNext.EpisodeTest do
  use ExUnit.Case

  import WhatsNext.Episode

  test "#next_air_date should return next entry in list" do
    assert "2011-06-30" == next_air_date(example_list, "1x01")
  end

  test "#next_air_date should return nil if there is no next entry" do
    assert nil == next_air_date(example_list, "20x01")
  end

  defp example_list do
    [["1x01", "2011-06-23"], ["1x02", "2011-06-30"], ["1x03", "2011-07-07"]]
  end

end
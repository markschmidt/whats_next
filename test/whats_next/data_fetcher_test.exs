defmodule WhatsNext.DataFetcherTest do
  use ExUnit.Case, async: false

  import Mock
  import WhatsNext.DataFetcher
  import MockingHelper

  test_with_mock "should fetch all data", HTTPotion, http_mock_options do
    series = "Suits"
    {:ok, body} = fetch(series)

    assert called HTTPotion.get("http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=allintitle:%20site:epguides.com%20#{series}")
    assert called HTTPotion.get("http://epguides.com/#{series}/")
  end

end

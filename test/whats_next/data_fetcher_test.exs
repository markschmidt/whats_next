defmodule WhatsNext.DataFetcherTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock

  import Mock
  import WhatsNext.DataFetcher

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes")
    :ok
  end

  test "should fetch all data" do
    use_cassette "requests_for_suits" do
      series = "Suits"
      {:ok, body} = fetch(series)
    end
  end

  test_with_mock "should return :error if the google query returns an empty list", HTTPotion, http_mock_options do
    {:error} = fetch("Some Name")
  end


  defp http_mock_options do
    [get: fn(url,_,_) ->
      body = case Regex.run(~r/https?:\/\/([^\/]+)\//, url) do
        [_, "ajax.googleapis.com"] -> empty_google_response
      end
      %HTTPotion.Response{body: body, status_code: 200, headers: nil}
    end]
  end

  defp empty_google_response do
    "{\"responseData\": {\"results\":[],\"cursor\":{\"resultCount\":\"1\",\"pages\":[{\"start\":\"0\",\"label\":1}],\"estimatedResultCount\":\"1\",\"currentPageIndex\":0,\"moreResultsUrl\":\"http://www.google.com/search?oe\\u003dutf8\\u0026ie\\u003dutf8\\u0026source\\u003duds\\u0026start\\u003d0\\u0026hl\\u003den\\u0026q\\u003dallintitle:+site:epguides.com+Suits\",\"searchResultTime\":\"0.11\"}}, \"responseDetails\": null, \"responseStatus\": 200}"
  end

end

defmodule WhatsNext.DataFetcherTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock

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

end

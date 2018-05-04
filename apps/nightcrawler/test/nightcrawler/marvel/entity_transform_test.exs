defmodule Nightcrawler.Marvel.EntityTransformTest do
  @moduledoc """
  This information is all from downloaded json's from the API itself,
  ideally it should be making api requests to get random items to test
  on but that is a TODO
  """
  use ExUnit.Case, async: true
  alias Nightcrawler.Parser
  alias Nightcrawler.Marvel.{Comic, Series, Event, Creator, Character}

  @spec date_from_iso(String.t()) :: DateTime.t()
  def date_from_iso(date) do
    {:ok, datetime, _} = DateTime.from_iso8601(date)
    datetime
  end

  setup do
    %{
      character: File.read!("test/test_data/character.json") |> Jason.decode!(),
      comic: File.read!("test/test_data/comic.json") |> Jason.decode!(),
      creator: File.read!("test/test_data/creator.json") |> Jason.decode!(),
      event: File.read!("test/test_data/event.json") |> Jason.decode!(),
      series: File.read!("test/test_data/series.json") |> Jason.decode!(),
      story: File.read!("test/test_data/story.json") |> Jason.decode!()
    }
  end

  test "Comic api result returns correct schema", %{comic: comic} do
    parsed = Parser.transform_entity(comic, Comic.transform)

    assert parsed.id == comic["id"]
    assert parsed.reader_id == comic["digitalId"]
    assert parsed.title == comic["title"]
    assert parsed.issue_number == comic["issueNumber"]
    assert parsed.page_count == comic["pageCount"]
    assert parsed.format == comic["format"]

    # this comic has the weird funky non date modified
    # assert parsed.modified == date_from_iso(comic["modified"])

    %{id: series_id} = Nightcrawler.Parser.api_url(comic["series"]["resourceURI"])
    assert parsed.series_id == series_id

    assert parsed.thumbnail.extension == comic["thumbnail"]["extension"]
    assert parsed.thumbnail.path == comic["thumbnail"]["path"]
  end
end

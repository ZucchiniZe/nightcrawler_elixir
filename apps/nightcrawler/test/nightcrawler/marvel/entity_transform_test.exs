defmodule Nightcrawler.Marvel.EntityTransformTest do
  @moduledoc """
  This information is all from downloaded json's from the API itself,
  ideally it should be making api requests to get random items to test
  on but that is a TODO
  """
  use ExUnit.Case, async: true
  alias Nightcrawler.Parser
  alias Nightcrawler.Marvel.{Comic, Series, Event, Creator, Character}

  @spec datetime_from_iso(String.t()) :: DateTime.t()
  def datetime_from_iso(date) do
    {:ok, datetime, _} = DateTime.from_iso8601(date)
    datetime
  end

  @spec date_from_iso(String.t()) :: Date.t()
  def date_from_iso(date) do
    date
    |> NaiveDateTime.from_iso8601!()
    |> NaiveDateTime.to_date()
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

  test "Comic transform matches api result", %{comic: comic} do
    parsed = Parser.transform_entity(comic, Comic.transform)

    assert parsed.id == comic["id"]
    assert parsed.reader_id == comic["digitalId"]
    assert parsed.title == comic["title"]
    assert parsed.issue_number == comic["issueNumber"]
    assert parsed.page_count == comic["pageCount"]
    assert parsed.format == comic["format"]

    # this comic has the weird funky non date modified
    # assert parsed.modified == datetime_from_iso(comic["modified"])

    %{id: series_id} = Nightcrawler.Parser.api_url(comic["series"]["resourceURI"])
    assert parsed.series_id == series_id

    assert parsed.thumbnail.extension == comic["thumbnail"]["extension"]
    assert parsed.thumbnail.path == comic["thumbnail"]["path"]
  end

  test "Comic transform returns valid changeset", %{comic: comic} do
    changeset = comic |> Parser.transform_entity(Comic.transform) |> Comic.changeset

    assert changeset.valid?
    assert changeset.changes.thumbnail.valid?
  end

  test "Series transform matches api result", %{series: series} do
    parsed = Parser.transform_entity(series, Series.transform)

    assert parsed.id == series["id"]
    assert parsed.title == series["title"]
    assert parsed.description == series["description"]
    assert parsed.rating == Series.parse_rating(series["rating"])
    assert parsed.start_year == series["startYear"]
    assert parsed.end_year == series["endYear"]
    assert parsed.modified == datetime_from_iso(series["modified"])

    assert parsed.thumbnail.extension == series["thumbnail"]["extension"]
    assert parsed.thumbnail.path == series["thumbnail"]["path"]
  end

  test "Series transform returns a valid changeset", %{series: series} do
    changeset = series |> Parser.transform_entity(Series.transform) |> Series.changeset

    assert changeset.valid?
    assert changeset.changes.thumbnail.valid?
  end

  test "Event transform matches api result", %{event: event} do
    parsed = Parser.transform_entity(event, Event.transform)

    assert parsed.id == event["id"]
    assert parsed.title == event["title"]
    assert parsed.description == event["description"]
    assert parsed.start == date_from_iso(event["start"])
    assert parsed.end == date_from_iso(event["end"])
    assert parsed.modified == datetime_from_iso(event["modified"])

    assert parsed.thumbnail.extension == event["thumbnail"]["extension"]
    assert parsed.thumbnail.path == event["thumbnail"]["path"]
  end

  test "Event transform returns a valid changeset", %{event: event} do
    changeset = event |> Parser.transform_entity(Event.transform) |> Event.changeset

    assert changeset.valid?
    assert changeset.changes.thumbnail.valid?
  end
end

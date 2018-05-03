defmodule Nightcrawler.Marvel.APIChangesetTest do
  @moduledoc """
  This information is all from downloaded json's from the API itself,
  ideally it should be making api requests to get random items to test
  on but that is a TODO
  """
  use ExUnit.Case, async: true
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

  test "Event api result conforms with spec", %{event: event} do
    changeset = Event.api_to_changeset(event)

    assert changeset.valid?

    assert changeset.changes.id == 116
    assert changeset.changes.title == "Acts of Vengeance!"

    assert changeset.changes.description ==
             "Loki sets about convincing the super-villains of Earth to attack heroes other than those they normally fight in an attempt to destroy the Avengers to absolve his guilt over inadvertently creating the team in the first place."

    assert changeset.changes.end == ~D[2008-01-04]
    assert changeset.changes.start == ~D[1989-12-10]
    assert changeset.changes.modified == date_from_iso("2013-06-28T16:31:24-0400")
    assert changeset.changes.thumbnail.changes.extension == "jpg"

    assert changeset.changes.thumbnail.changes.path ==
             "https://i.annihil.us/u/prod/marvel/i/mg/9/40/51ca10d996b8b"
  end

  test "Comic api result conforms with spec", %{comic: comic} do
    changeset = Comic.api_to_changeset(comic)

    assert changeset.valid?

    assert changeset.changes.id == 11_731
    assert changeset.changes.reader_id == 30_399
    assert changeset.changes.title == "Thor (1966) #403"
    assert changeset.changes.issue_number == 403.0
    assert changeset.changes.page_count == 36
    assert changeset.changes.modified == date_from_iso("1989-05-10T00:00:00-0400")
    assert changeset.changes.format == "Comic"
    assert changeset.changes.series_id == 2083

    refute Map.has_key?(changeset.changes, :description)
    refute Map.has_key?(changeset.changes, :isbn)
  end

  test "Character.api_to_changeset/1 returns a valid changeset", %{character: char} do
    changeset = Character.api_to_changeset(char)

    assert changeset.valid?
  end

  test "Series.api_to_changset/1 returns a valid changeset", %{series: series} do
    changeset = Series.api_to_changeset(series)

    assert changeset.valid?
  end

  test "test parse_rating" do
    # all the available ratings from the marvel api
    ratings = [
      "RATED T+",
      "ALL AGES",
      "MARVEL PSR",
      "RATED A",
      "Rated T+",
      "PARENTAL ADVISORY",
      "T",
      "T+",
      "All Ages",
      "Parental Advisory",
      "Rated T",
      "Marvel Psr",
      "EXPLICIT CONTENT",
      "A",
      "RATED T",
      "NO RATING",
      "Rated a",
      "PARENTAL ADVISORY/EXPLICIT CONTENT",
      "MARVEL PSR+",
      "NOT IN ORACLE",
      "Mature",
      "PARENTAL ADVISORYSLC",
      "Rated A",
      "Not in Oracle",
      "MAX: EXPLICIT CONTENT",
      "MARVEL AGE (12+)",
      "Parental Advisory/Explicit Content",
      "Explicit Content",
      "Parental Guidance",
      "AGES 12 & UP",
      "Max: Explicit Content",
      "PARENTAL SUPERVISION",
      "17 AND UP",
      "17 & UP",
      "No Rating",
      "13 & Up",
      "PG",
      " ",
      "Parental Advisoryslc"
    ]

    all_ratings =
      ratings
      |> Enum.map(&Series.parse_rating/1)
      |> Enum.uniq()
      |> Enum.sort()

    assert all_ratings == [
             "All Ages",
             "Max: Explicit Content",
             "No Rating",
             "Parental Advisory",
             "T",
             "T+"
           ]
  end
end

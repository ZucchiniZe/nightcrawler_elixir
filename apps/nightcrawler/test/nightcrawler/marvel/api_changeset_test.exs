defmodule Nightcrawler.Marvel.APIChangesetTest do
  use ExUnit.Case
  alias Nightcrawler.Marvel.{Comic, Series, Event, Creator, Character}

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

  test "Event.api_to_changeset/1 returns a valid changeset", %{event: event} do
    changeset = Event.api_to_changeset(event)

    assert changeset.valid?
  end

  test "Comic.api_to_changeset/1 returns a valid changeset", %{comic: comic} do
    changeset = Comic.api_to_changeset(comic)

    assert changeset.valid?

    # since we do some special stuff to make sure the modified works, we need to
    # make sure it is in the changeset
    assert Map.has_key?(changeset.changes, :modified)
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

    assert all_ratings = [
             "All Ages",
             "Max: Explicit Content",
             "No Rating",
             "Parental Advisory",
             "T",
             "T+"
           ]
  end
end

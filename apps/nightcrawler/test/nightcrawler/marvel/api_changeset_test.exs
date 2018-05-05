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

  test "Character api result conforms with spec", %{character: char} do
    changeset = Character.api_to_changeset(char)

    assert changeset.valid?
    assert changeset.changes.thumbnail.valid?

    assert changeset.changes.id == 1_009_368
    assert changeset.changes.name == "Iron Man"
    assert changeset.changes.description == "Wounded, captured and forced to build a weapon by his enemies, billionaire industrialist Tony Stark instead created an advanced suit of armor to save his life and escape captivity. Now with a new outlook on life, Tony uses his money and intelligence to make the world a safer, better place as Iron Man."
    assert changeset.changes.modified == date_from_iso("2016-09-28T12:08:19-0400")
  end

  test "Creator api result conforms with spec", %{creator: creator} do
    changeset = Creator.api_to_changeset(creator)

    assert changeset.valid?
    assert changeset.changes.thumbnail.valid?

    assert changeset.changes.id == 196
    assert changeset.changes.first_name == "Jack"
    assert changeset.changes.last_name == "Kirby"
    assert changeset.changes.full_name == "Jack Kirby"
    assert changeset.changes.modified == date_from_iso("2015-10-20T12:46:18-0400")
  end
end

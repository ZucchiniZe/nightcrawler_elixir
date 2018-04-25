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
    assert Map.has_key?(changeset.changes, :modified)
  end
end

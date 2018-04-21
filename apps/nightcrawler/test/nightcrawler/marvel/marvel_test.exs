defmodule Nightcrawler.MarvelTest do
  @moduledoc false
  use Nightcrawler.DataCase

  alias Nightcrawler.Marvel

  describe "series" do
    alias Nightcrawler.Marvel.Series

    @valid_attrs %{description: "some description", end_year: 42, marvel_id: 42, modified: "2010-04-17 14:00:00.000000Z", rating: "some rating", start_year: 42, title: "some title"}
    @update_attrs %{description: "some updated description", end_year: 43, marvel_id: 43, modified: "2011-05-18 15:01:01.000000Z", rating: "some updated rating", start_year: 43, title: "some updated title"}
    @invalid_attrs %{description: nil, end_year: nil, marvel_id: nil, modified: nil, rating: nil, start_year: nil, title: nil}

    def series_fixture(attrs \\ %{}) do
      {:ok, series} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Marvel.create_series()

      series
    end

    test "list_series/0 returns all series" do
      series = series_fixture()
      assert Marvel.list_series() == [series]
    end

    test "get_series!/1 returns the series with given id" do
      series = series_fixture()
      assert Marvel.get_series!(series.id) == series
    end

    test "create_series/1 with valid data creates a series" do
      assert {:ok, %Series{} = series} = Marvel.create_series(@valid_attrs)
      assert series.description == "some description"
      assert series.end_year == 42
      assert series.marvel_id == 42
      assert series.modified == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert series.rating == "some rating"
      assert series.start_year == 42
      assert series.title == "some title"
    end

    test "create_series/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Marvel.create_series(@invalid_attrs)
    end

    test "update_series/2 with valid data updates the series" do
      series = series_fixture()
      assert {:ok, series} = Marvel.update_series(series, @update_attrs)
      assert %Series{} = series
      assert series.description == "some updated description"
      assert series.end_year == 43
      assert series.marvel_id == 43
      assert series.modified == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert series.rating == "some updated rating"
      assert series.start_year == 43
      assert series.title == "some updated title"
    end

    test "update_series/2 with invalid data returns error changeset" do
      series = series_fixture()
      assert {:error, %Ecto.Changeset{}} = Marvel.update_series(series, @invalid_attrs)
      assert series == Marvel.get_series!(series.id)
    end

    test "delete_series/1 deletes the series" do
      series = series_fixture()
      assert {:ok, %Series{}} = Marvel.delete_series(series)
      assert_raise Ecto.NoResultsError, fn -> Marvel.get_series!(series.id) end
    end

    test "change_series/1 returns a series changeset" do
      series = series_fixture()
      assert %Ecto.Changeset{} = Marvel.change_series(series)
    end
  end

  describe "comics" do
    alias Nightcrawler.Marvel.Comic

    @valid_attrs %{description: "some description", format: "some format", isbn: "some isbn", issue_number: 42, marvel_id: 42, modified: "2010-04-17 14:00:00.000000Z", page_count: 42, reader_id: 42, title: "some title"}
    @update_attrs %{description: "some updated description", format: "some updated format", isbn: "some updated isbn", issue_number: 43, marvel_id: 43, modified: "2011-05-18 15:01:01.000000Z", page_count: 43, reader_id: 43, title: "some updated title"}
    @invalid_attrs %{description: nil, format: nil, isbn: nil, issue_number: nil, marvel_id: nil, modified: nil, page_count: nil, reader_id: nil, title: nil}

    def comic_fixture(attrs \\ %{}) do
      {:ok, comic} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Marvel.create_comic()

      comic
    end

    test "list_comics/0 returns all comics" do
      comic = comic_fixture()
      assert Marvel.list_comics() == [comic]
    end

    test "get_comic!/1 returns the comic with given id" do
      comic = comic_fixture()
      assert Marvel.get_comic!(comic.id) == comic
    end

    test "create_comic/1 with valid data creates a comic" do
      assert {:ok, %Comic{} = comic} = Marvel.create_comic(@valid_attrs)
      assert comic.description == "some description"
      assert comic.format == "some format"
      assert comic.isbn == "some isbn"
      assert comic.issue_number == 42
      assert comic.marvel_id == 42
      assert comic.modified == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert comic.page_count == 42
      assert comic.reader_id == 42
      assert comic.title == "some title"
    end

    test "create_comic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Marvel.create_comic(@invalid_attrs)
    end

    test "update_comic/2 with valid data updates the comic" do
      comic = comic_fixture()
      assert {:ok, comic} = Marvel.update_comic(comic, @update_attrs)
      assert %Comic{} = comic
      assert comic.description == "some updated description"
      assert comic.format == "some updated format"
      assert comic.isbn == "some updated isbn"
      assert comic.issue_number == 43
      assert comic.marvel_id == 43
      assert comic.modified == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert comic.page_count == 43
      assert comic.reader_id == 43
      assert comic.title == "some updated title"
    end

    test "update_comic/2 with invalid data returns error changeset" do
      comic = comic_fixture()
      assert {:error, %Ecto.Changeset{}} = Marvel.update_comic(comic, @invalid_attrs)
      assert comic == Marvel.get_comic!(comic.id)
    end

    test "delete_comic/1 deletes the comic" do
      comic = comic_fixture()
      assert {:ok, %Comic{}} = Marvel.delete_comic(comic)
      assert_raise Ecto.NoResultsError, fn -> Marvel.get_comic!(comic.id) end
    end

    test "change_comic/1 returns a comic changeset" do
      comic = comic_fixture()
      assert %Ecto.Changeset{} = Marvel.change_comic(comic)
    end
  end

  describe "creators" do
    alias Nightcrawler.Marvel.Creator

    @valid_attrs %{first_name: "some first_name", full_name: "some full_name", last_name: "some last_name", marvel_id: 42, middle_name: "some middle_name", modified: "2010-04-17 14:00:00.000000Z", suffix: "some suffix"}
    @update_attrs %{first_name: "some updated first_name", full_name: "some updated full_name", last_name: "some updated last_name", marvel_id: 43, middle_name: "some updated middle_name", modified: "2011-05-18 15:01:01.000000Z", suffix: "some updated suffix"}
    @invalid_attrs %{first_name: nil, full_name: nil, last_name: nil, marvel_id: nil, middle_name: nil, modified: nil, suffix: nil}

    def creator_fixture(attrs \\ %{}) do
      {:ok, creator} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Marvel.create_creator()

      creator
    end

    test "list_creators/0 returns all creators" do
      creator = creator_fixture()
      assert Marvel.list_creators() == [creator]
    end

    test "get_creator!/1 returns the creator with given id" do
      creator = creator_fixture()
      assert Marvel.get_creator!(creator.id) == creator
    end

    test "create_creator/1 with valid data creates a creator" do
      assert {:ok, %Creator{} = creator} = Marvel.create_creator(@valid_attrs)
      assert creator.first_name == "some first_name"
      assert creator.full_name == "some full_name"
      assert creator.last_name == "some last_name"
      assert creator.marvel_id == 42
      assert creator.middle_name == "some middle_name"
      assert creator.modified == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert creator.suffix == "some suffix"
    end

    test "create_creator/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Marvel.create_creator(@invalid_attrs)
    end

    test "update_creator/2 with valid data updates the creator" do
      creator = creator_fixture()
      assert {:ok, creator} = Marvel.update_creator(creator, @update_attrs)
      assert %Creator{} = creator
      assert creator.first_name == "some updated first_name"
      assert creator.full_name == "some updated full_name"
      assert creator.last_name == "some updated last_name"
      assert creator.marvel_id == 43
      assert creator.middle_name == "some updated middle_name"
      assert creator.modified == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert creator.suffix == "some updated suffix"
    end

    test "update_creator/2 with invalid data returns error changeset" do
      creator = creator_fixture()
      assert {:error, %Ecto.Changeset{}} = Marvel.update_creator(creator, @invalid_attrs)
      assert creator == Marvel.get_creator!(creator.id)
    end

    test "delete_creator/1 deletes the creator" do
      creator = creator_fixture()
      assert {:ok, %Creator{}} = Marvel.delete_creator(creator)
      assert_raise Ecto.NoResultsError, fn -> Marvel.get_creator!(creator.id) end
    end

    test "change_creator/1 returns a creator changeset" do
      creator = creator_fixture()
      assert %Ecto.Changeset{} = Marvel.change_creator(creator)
    end
  end

  describe "characters" do
    alias Nightcrawler.Marvel.Character

    @valid_attrs %{description: "some description", marvel_id: 42, modified: "2010-04-17 14:00:00.000000Z", name: "some name"}
    @update_attrs %{description: "some updated description", marvel_id: 43, modified: "2011-05-18 15:01:01.000000Z", name: "some updated name"}
    @invalid_attrs %{description: nil, marvel_id: nil, modified: nil, name: nil}

    def character_fixture(attrs \\ %{}) do
      {:ok, character} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Marvel.create_character()

      character
    end

    test "list_characters/0 returns all characters" do
      character = character_fixture()
      assert Marvel.list_characters() == [character]
    end

    test "get_character!/1 returns the character with given id" do
      character = character_fixture()
      assert Marvel.get_character!(character.id) == character
    end

    test "create_character/1 with valid data creates a character" do
      assert {:ok, %Character{} = character} = Marvel.create_character(@valid_attrs)
      assert character.description == "some description"
      assert character.marvel_id == 42
      assert character.modified == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert character.name == "some name"
    end

    test "create_character/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Marvel.create_character(@invalid_attrs)
    end

    test "update_character/2 with valid data updates the character" do
      character = character_fixture()
      assert {:ok, character} = Marvel.update_character(character, @update_attrs)
      assert %Character{} = character
      assert character.description == "some updated description"
      assert character.marvel_id == 43
      assert character.modified == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert character.name == "some updated name"
    end

    test "update_character/2 with invalid data returns error changeset" do
      character = character_fixture()
      assert {:error, %Ecto.Changeset{}} = Marvel.update_character(character, @invalid_attrs)
      assert character == Marvel.get_character!(character.id)
    end

    test "delete_character/1 deletes the character" do
      character = character_fixture()
      assert {:ok, %Character{}} = Marvel.delete_character(character)
      assert_raise Ecto.NoResultsError, fn -> Marvel.get_character!(character.id) end
    end

    test "change_character/1 returns a character changeset" do
      character = character_fixture()
      assert %Ecto.Changeset{} = Marvel.change_character(character)
    end
  end

  describe "events" do
    alias Nightcrawler.Marvel.Event

    @valid_attrs %{description: "some description", end: ~D[2010-04-17], marvel_id: 42, modified: "2010-04-17 14:00:00.000000Z", start: ~D[2010-04-17], title: "some title"}
    @update_attrs %{description: "some updated description", end: ~D[2011-05-18], marvel_id: 43, modified: "2011-05-18 15:01:01.000000Z", start: ~D[2011-05-18], title: "some updated title"}
    @invalid_attrs %{description: nil, end: nil, marvel_id: nil, modified: nil, start: nil, title: nil}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Marvel.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Marvel.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Marvel.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Marvel.create_event(@valid_attrs)
      assert event.description == "some description"
      assert event.end == ~D[2010-04-17]
      assert event.marvel_id == 42
      assert event.modified == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert event.start == ~D[2010-04-17]
      assert event.title == "some title"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Marvel.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, event} = Marvel.update_event(event, @update_attrs)
      assert %Event{} = event
      assert event.description == "some updated description"
      assert event.end == ~D[2011-05-18]
      assert event.marvel_id == 43
      assert event.modified == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert event.start == ~D[2011-05-18]
      assert event.title == "some updated title"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Marvel.update_event(event, @invalid_attrs)
      assert event == Marvel.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Marvel.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Marvel.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Marvel.change_event(event)
    end
  end
end

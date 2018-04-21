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
end

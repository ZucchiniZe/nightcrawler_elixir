defmodule Nightcrawler.Marvel do
  @moduledoc """
  The Marvel context.
  """

  import Ecto.Query, warn: false
  alias Nightcrawler.Repo
  alias Nightcrawler.Marvel.{Comic, Series, Event, Creator, Character}

  def list_series do
    Repo.all(Series)
  end

  def get_series!(id), do: Repo.get!(Series, id)

  def create_series(attrs \\ %{}) do
    %Series{}
    |> Series.changeset(attrs)
    |> Repo.insert()
  end

  def update_series(%Series{} = series, attrs) do
    series
    |> Series.changeset(attrs)
    |> Repo.update()
  end

  def delete_series(%Series{} = series) do
    Repo.delete(series)
  end

  def change_series(%Series{} = series) do
    Series.changeset(series, %{})
  end

  def list_comics do
    Repo.all(Comic)
  end

  def get_comic!(id), do: Repo.get!(Comic, id)

  def create_comic(attrs \\ %{}) do
    %Comic{}
    |> Comic.changeset(attrs)
    |> Repo.insert()
  end

  def update_comic(%Comic{} = comic, attrs) do
    comic
    |> Comic.changeset(attrs)
    |> Repo.update()
  end

  def delete_comic(%Comic{} = comic) do
    Repo.delete(comic)
  end

  def change_comic(%Comic{} = comic) do
    Comic.changeset(comic, %{})
  end

  def list_creators do
    Repo.all(Creator)
  end

  def get_creator!(id), do: Repo.get!(Creator, id)

  def create_creator(attrs \\ %{}) do
    %Creator{}
    |> Creator.changeset(attrs)
    |> Repo.insert()
  end

  def update_creator(%Creator{} = creator, attrs) do
    creator
    |> Creator.changeset(attrs)
    |> Repo.update()
  end

  def delete_creator(%Creator{} = creator) do
    Repo.delete(creator)
  end

  def change_creator(%Creator{} = creator) do
    Creator.changeset(creator, %{})
  end

  def list_characters do
    Repo.all(Character)
  end

  def get_character!(id), do: Repo.get!(Character, id)

  def create_character(attrs \\ %{}) do
    %Character{}
    |> Character.changeset(attrs)
    |> Repo.insert()
  end

  def update_character(%Character{} = character, attrs) do
    character
    |> Character.changeset(attrs)
    |> Repo.update()
  end

  def delete_character(%Character{} = character) do
    Repo.delete(character)
  end

  def change_character(%Character{} = character) do
    Character.changeset(character, %{})
  end

  def list_events do
    Repo.all(Event)
  end

  def get_event!(id), do: Repo.get!(Event, id)

  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end

  @doc """
  takes the raw api result and just bulk inserts into the database

  expects the response.data.results from json, thankfully
  `Marvel.get_all/1` returns a compatible list
  """
  def bulk_insert_events(api_result) do
    api_result
    |> Enum.map(&Event.api_to_changeset/1)
    |> Enum.reduce(Ecto.Multi.new(), fn cset, multi ->
      Ecto.Multi.insert_or_update(multi, Ecto.UUID.generate(), cset)
    end)
    |> Repo.transaction()
  end
end

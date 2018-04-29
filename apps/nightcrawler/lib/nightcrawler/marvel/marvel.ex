defmodule Nightcrawler.Marvel do
  @moduledoc """
  The Marvel context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Nightcrawler.Repo
  alias Nightcrawler.Marvel.{Comic, Series, Story, Event, Creator, Character}

  @doc """
  takes the raw api result and just bulk inserts into the database

  expects the response.data.results from json, thankfully
  `Marvel.get_all/1` returns a compatible list

  `entity` must conform to the `Nightcrawler.Marvel.Entity` behaviour
  """
  def bulk_insert_entity(api_result, entity) do
    # TODO: error handling
    api_result
    |> Enum.map(&apply(entity, :api_to_changeset, [&1]))
    # Above step returns a list of changesets, we need a way to insert them into
    # the database reliably. We can use SQL transactions using `Ecto.Multi` to
    # make sure everything is inserted at the same time.
    # We want to boil the list of changesets down to one single value, and in
    # this case, that value is a `Ecto.Multi` struct. Each operation added to
    # the multi needs to have a name so, we generate a random UUID value for
    # them using `Ecto.UUID.generate` so there are no name conflicts
    # the `on_conflict: :replace_all` provides us with a postgresql upsert for
    # inserting already existing data
    |> Enum.reduce(Multi.new(), fn cset, multi ->
      Multi.insert(multi, Ecto.UUID.generate, cset, on_conflict: :replace_all)
    end)
    |> Repo.transaction()
  end

  def list_series do
    Repo.all(Series)
  end

  def get_series!(id), do: Repo.get!(Series, id)

  def delete_series(%Series{} = series) do
    Repo.delete(series)
  end

  def list_comics do
    Repo.all(Comic)
  end

  def get_comic!(id), do: Repo.get!(Comic, id)

  def delete_comic(%Comic{} = comic) do
    Repo.delete(comic)
  end

  def list_creators do
    Repo.all(Creator)
  end

  def get_creator!(id), do: Repo.get!(Creator, id)

  def delete_creator(%Creator{} = creator) do
    Repo.delete(creator)
  end

  def list_characters do
    Repo.all(Character)
  end

  def get_character!(id), do: Repo.get!(Character, id)

  def delete_character(%Character{} = character) do
    Repo.delete(character)
  end

  def list_events do
    Repo.all(Event)
  end

  def get_event!(id), do: Repo.get!(Event, id)
  
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  def list_stories do
    Repo.all(Story)
  end

  def get_story!(id), do: Repo.get!(Story, id)

  def delete_story(%Story = story) do
    Repo.delete(story)
  end
end

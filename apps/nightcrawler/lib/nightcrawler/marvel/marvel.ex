defmodule Nightcrawler.Marvel do
  @moduledoc """
  The Marvel context.
  """
  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Nightcrawler.Repo
  alias Nightcrawler.Marvel.{Comic, Series, Story, Event, Creator, Character}
  alias Nightcrawler.Parser

  @doc """
  takes the raw api result and just bulk inserts into the database

  expects the response.data.results from json, thankfully
  `Marvel.get_all/1` returns a compatible list

  `entity` must conform to the `Nightcrawler.Marvel.Entity` behaviour
  """
  def bulk_insert_entity(api_result, entity, chunking \\ 100) do
    # TODO: error handling
    api_result
    # |> Stream.map(&apply(entity, :api_to_changeset, [&1]))
    |> Stream.map(&Parser.transform_entity(&1, entity.transform))
    # Above step returns a list of changesets, we need a way to insert them into
    # the database reliably. We can use SQL transactions using `Ecto.Multi` to
    # make sure everything is inserted at the same time.
    |> Stream.chunk_every(chunking)
    # Because we are usually dealing with a lot of data we want to use streams
    # and to chunk it so the proccessing can be done without running out of memory

    # Because we have a list of lists now we can map on each of the lists inside of
    # the larger list and then reduce it into an `Ecto.Multi` for a nice transaction
    |> Stream.map(fn changesets ->
      # We want to boil the list of changesets down to one single value, and in
      # this case, that value is a `Ecto.Multi` struct. Each operation added to
      # the multi needs to have a name so, we generate a random UUID value for
      # them using `Ecto.UUID.generate` so there are no name conflicts.

      # The `on_conflict: :replace_all` provides us with a postgresql upsert for
      # inserting already existing data. we use `conflict_target: :id` to check
      # for a conflict if there is an already exisiting row with the same id
      Enum.reduce(changesets, Multi.new(), fn cset, multi ->
        Multi.insert(
          multi,
          Ecto.UUID.generate(),
          cset,
          on_conflict: :replace_all,
          conflict_target: :id
        )
      end)
    end)
    # Now we have a list of `Ecto.Multi`s and ecto conviently supplies us with
    # `Ecto.Multi.append/2` to conjoin two multis together to supply to the
    # transaction
    |> Enum.reduce(Multi.new(), fn change, multi ->
      Multi.append(multi, change)
    end)
    # because we run this on a bulk insert it means that we can have upwards of
    # 20,000 items inserted at a time. Ecto's default timeout is 15 seconds
    # which doesn't really work for this case so we use an infinite timeout
    # for this case only
    |> Repo.transaction(timeout: :infinity)
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

  def delete_story(%Story{} = story) do
    Repo.delete(story)
  end
end

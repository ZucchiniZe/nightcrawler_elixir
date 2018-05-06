defmodule Nightcrawler.Marvel.Event do
  @moduledoc false
  @behaviour Nightcrawler.Marvel.Entity
  use Ecto.Schema
  import Ecto.Changeset
  alias Nightcrawler.Parser

  schema "events" do
    field(:description, :string)
    field(:end, :date)
    field(:modified, :utc_datetime)
    field(:start, :date)
    field(:title, :string)

    embeds_one(:thumbnail, Nightcrawler.Marvel.Common.Image)

    many_to_many(:series, Nightcrawler.Marvel.Series, join_through: "series_events")

    timestamps()
  end

  def changeset(attrs), do: changeset(%__MODULE__{}, attrs)

  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title, :description, :id, :start, :end, :modified])
    |> cast_embed(:thumbnail)
    |> validate_required([:title, :description, :id, :modified])
  end

  def transform do
    %{
      id: &Parser.integer_or_string/1,
      title: &Parser.integer_or_string/1,
      description: &Parser.integer_or_string/1,
      start: &transform_date/1,
      end: &transform_date/1,
      modified: &Parser.maybe_datetime/1,
      thumbnail: &Parser.thumbnail/1
    }
  end

  def transform_date({key, val}) do
    key_atom = String.to_existing_atom(key)

    date =
      val
      |> NaiveDateTime.from_iso8601!()
      |> NaiveDateTime.to_date()

    {key_atom, date}
  end
end

defmodule Nightcrawler.Marvel.Character do
  @moduledoc false
  @behaviour Nightcrawler.Marvel.Entity
  use Ecto.Schema
  import Ecto.Changeset
  alias Nightcrawler.Parser

  schema "characters" do
    field(:description, :string)
    field(:modified, :utc_datetime)
    field(:name, :string)

    embeds_one(:thumbnail, Nightcrawler.Marvel.Common.Image)

    many_to_many(:series, Nightcrawler.Marvel.Series, join_through: "series_characters")

    timestamps()
  end

  def changeset(attrs), do: changeset(%__MODULE__{}, attrs)

  def changeset(character, attrs) do
    character
    |> cast(attrs, [:name, :id, :description, :modified])
    |> validate_required([:name, :id, :modified])
    |> cast_embed(:thumbnail)
  end

  def transform do
    %{
      id: &Parser.integer_or_string/1,
      name: &Parser.integer_or_string/1,
      description: &Parser.integer_or_string/1,
      modified: &Parser.maybe_datetime/1,
      thumbnail: &Parser.thumbnail/1
    }
  end
end

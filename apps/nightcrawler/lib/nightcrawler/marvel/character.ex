defmodule Nightcrawler.Marvel.Character do
  @moduledoc false
  @behaviour Nightcrawler.Marvel.Entity
  use Ecto.Schema
  import Ecto.Changeset

  schema "characters" do
    field :description, :string
    field :modified, :utc_datetime
    field :name, :string

    embeds_one :thumbnail, Nightcrawler.Marvel.Common.Image

    many_to_many :comics, Nightcrawler.Marvel.Comic, join_through: "comics_characters"

    timestamps()
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [:name, :id, :description, :modified])
    |> validate_required([:name, :id, :modified])
    |> cast_embed(:thumbnail)
  end

  def api_to_changeset(data) do
    attrs =
      data
      |> Enum.reduce(%{}, &parse_values/2)
      |> Map.new

    changeset(%__MODULE__{}, attrs)
  end

  def parse_values({k, v}, acc) do
    key = String.to_atom(k)

    cond do
      key == :modified ->
        {:ok, datetime, _} = DateTime.from_iso8601(v)

        Map.put(acc, key, datetime)

      key in ~w(name description id thumbnail)a ->
        Map.put(acc, key, v)

      true ->
        acc
    end
  end
end

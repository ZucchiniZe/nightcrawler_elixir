defmodule Nightcrawler.Marvel.Character do
  @moduledoc false
  @behaviour Nightcrawler.Marvel.Entity
  use Ecto.Schema
  import Ecto.Changeset


  schema "characters" do
    field :description, :string
    field :modified, :utc_datetime
    field :name, :string

    many_to_many :comics, Nightcrawler.Marvel.Comic, join_through: "comics_characters"

    timestamps()
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [:name, :id, :description, :modified])
    |> validate_required([:name, :id, :description, :modified])
  end

  def api_to_changeset(data) do
    attrs =
      data
      |> Enum.map(&parse_values/1)
      |> Enum.into(%{})

    changeset(%Nightcrawler.Marvel.Character{}, attrs)
  end

  def parse_values({k, v}) do
    key = String.to_atom(k)

    cond do
      key == :id ->
        {key, v}

      key == :modified ->
        {:ok, datetime, _} = DateTime.from_iso8601(v)

        {key, datetime}

      key in ~w(name description)a ->
        {key, v}

      true ->
        {nil, nil}
    end
  end
end

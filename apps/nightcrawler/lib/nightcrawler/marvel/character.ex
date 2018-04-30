defmodule Nightcrawler.Marvel.Character do
  @moduledoc false
  @behaviour Nightcrawler.Marvel.Entity
  use Ecto.Schema
  alias Nightcrawler.Repo
  alias Nightcrawler.Marvel.Comic
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

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
    |> put_assoc(:comics, insert_and_get_comics(attrs.comics))
  end

  defp insert_and_get_comics([]), do: []
  defp insert_and_get_comics(comics) do
    ids = Enum.map(comics, & &1.id)
    timestamped = Enum.map(comics, &add_timestamps/1)

    Repo.insert_all(Comic, timestamped, on_conflict: :nothing)

    select_inserted =
      from c in Comic,
        where: c.id in ^ids,
        select: c.id

    select_inserted
    |> Repo.all
    |> Enum.map(&%{id: &1})
  end

  defp add_timestamps(row) do
    row
    |> Map.put(:inserted_at, DateTime.utc_now())
    |> Map.put(:updated_at, DateTime.utc_now())
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
      key == :comics ->
        comics =
          v["items"]
          |> Enum.map(fn item ->
            %{id: id} = Nightcrawler.Parser.api_url(item["resourceURI"])
            %{id: id, title: item["name"]}
          end)

        Map.put(acc, key, comics)

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

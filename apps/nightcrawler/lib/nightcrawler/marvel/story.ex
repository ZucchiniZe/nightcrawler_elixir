defmodule Nightcrawler.Marvel.Story do
  @moduledoc false
  @behaviour Nightcrawler.Marvel.Entity
  use Ecto.Schema
  import Ecto.Changeset

  schema "stories" do
    field(:title, :string)
    field(:description, :string)
    field(:type, :string)
    field(:modified, :utc_datetime)

    embeds_one(:thumbnail, Nightcrawler.Marvel.Common.Image)

    timestamps()
  end

  def changeset(story, attrs) do
    story
    |> cast(attrs, [:title, :description, :type, :modified])
    |> cast_embed(:thumbnail)
    |> validate_required([:title, :type])
  end

  def api_to_changeset(data) do
    attrs =
      data
      |> Enum.reduce(%{}, &parse_values/2)
      |> Map.new()

    changeset(%__MODULE__{}, attrs)
  end

  defp parse_values({k, v}, acc) do
    key = String.to_atom(k)

    cond do
      key == :modified ->
        {:ok, datetime, _} = DateTime.from_iso8601(v)

        Map.put(acc, key, datetime)

      key in ~w(title description type id thumbnail)a ->
        Map.put(acc, key, v)

      true ->
        acc
    end
  end
end

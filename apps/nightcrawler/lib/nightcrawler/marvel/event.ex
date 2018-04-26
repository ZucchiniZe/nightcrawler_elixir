defmodule Nightcrawler.Marvel.Event do
  @moduledoc false
  @behaviour Nightcrawler.Marvel.Entity
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :title, :description, :modified, :start, :end]}

  schema "events" do
    field(:description, :string)
    field(:end, :date)
    field(:modified, :utc_datetime)
    field(:start, :date)
    field(:title, :string)

    many_to_many(:comics, Nightcrawler.Marvel.Comic, join_through: "comics_events")

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title, :description, :id, :start, :end, :modified])
    |> validate_required([:title, :description, :id, :modified])
  end

  @doc """
  Parses the marvel API result into a changeset friendly map and then returns a changeset
  """
  def api_to_changeset(data) do
    attrs =
      data
      |> Enum.reduce(%{}, &parse_values/2)
      |> Enum.into(%{})

    changeset(%Nightcrawler.Marvel.Event{}, attrs)
  end

  defp parse_values({k, v}, acc) do
    key = String.to_atom(k)

    cond do
      key == :modified ->
        {:ok, datetime, _} = DateTime.from_iso8601(v)

        Map.put(acc, key, datetime)

      key in ~w(start end)a and v != nil ->
        date =
          NaiveDateTime.from_iso8601!(v)
          |> NaiveDateTime.to_date()

        Map.put(acc, key, date)

      key in ~w(title description id)a ->
        Map.put(acc, key, v)

      true ->
        acc
    end
  end
end

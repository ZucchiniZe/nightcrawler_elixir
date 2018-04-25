defmodule Nightcrawler.Marvel.Comic do
  @moduledoc false
  @behaviour Nightcrawler.Marvel.Entity
  use Ecto.Schema
  import Ecto.Changeset

  schema "comics" do
    field(:description, :string)
    field(:format, :string)
    field(:isbn, :string)
    field(:issue_number, :integer)
    field(:marvel_id, :id)
    field(:modified, :utc_datetime)
    field(:page_count, :integer)
    field(:reader_id, :integer)
    field(:title, :string)

    belongs_to(:series, Nightcrawler.Marvel.Series)
    many_to_many(:creators, Nightcrawler.Marvel.Creator, join_through: "comics_creators")
    many_to_many(:characters, Nightcrawler.Marvel.Character, join_through: "comics_characters")
    many_to_many(:events, Nightcrawler.Marvel.Event, join_through: "comics_events")

    timestamps()
  end

  @doc false
  def changeset(comic, attrs) do
    comic
    |> cast(attrs, [
      :title,
      :reader_id,
      :marvel_id,
      :issue_number,
      :modified,
      :description,
      :isbn,
      :format,
      :page_count
    ])
    |> validate_required([:title, :marvel_id, :issue_number])
  end

  def api_to_changeset(data) do
    attrs =
      data
      |> Enum.reduce(%{}, &parse_values/2)
      |> Enum.into(%{})

    changeset(%Nightcrawler.Marvel.Comic{}, attrs)
  end

  def parse_values({k, v}, acc) do
    key = String.to_atom(k)

    cond do
      key == :id ->
        Map.put(acc, :marvel_id, v)

      # try to parse the modified date, if not ignore
      key == :modified ->
        case DateTime.from_iso8601(v) do
          {:ok, datetime, _} ->
            Map.put(acc, key, datetime)

          {:error, _} ->
            acc
        end

      # fallback for the modified date, get the onsaleDate
      key == :dates ->
        unless Map.has_key?(acc, :modified) do
          date =
            Enum.filter(v, fn date -> date["type"] == "onsaleDate" end)
            |> List.first()
            |> Map.get("date")

          {:ok, datetime, _} = DateTime.from_iso8601(date)

          Map.put(acc, :modified, datetime)
        end

      key in ~w(issueNumber pageCount)a ->
        underscored = Macro.underscore(k)

        Map.put(acc, String.to_atom(underscored), v)

      key in ~w(title description isbn format)a ->
        Map.put(acc, key, v)

      true ->
        acc
    end
  end
end

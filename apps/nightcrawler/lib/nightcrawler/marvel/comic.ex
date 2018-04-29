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
      :id,
      :issue_number,
      :modified,
      :description,
      :isbn,
      :format,
      :page_count
    ])
    |> validate_required([:title, :id, :issue_number, :modified])
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
      key == :digitalId ->
        Map.put(acc, :reader_id, v)

      # try to parse the modified date, if not ignore
      key == :modified ->
        case DateTime.from_iso8601(v) do
          {:ok, datetime, _} ->
            Map.put(acc, key, datetime)

          {:error, _} ->
            acc
        end

      # fallback for the modified date, get the onsaleDate
      key == :dates and not Map.has_key?(acc, :modified) ->
        date = filter_saledate(v)

        {:ok, datetime, _} = DateTime.from_iso8601(date)

        Map.put(acc, :modified, datetime)

      key in ~w(issueNumber pageCount)a ->
        underscored = Macro.underscore(k) |> String.to_atom()

        Map.put(acc, underscored, v)

      key in ~w(title description isbn format id)a ->
        Map.put(acc, key, v)

      true ->
        acc
    end
  end

  defp filter_saledate(dates) do
    dates
    |> Enum.filter(fn date -> date["type"] == "onsaleDate" end)
    |> List.first()
    |> Map.get("date")
  end
end

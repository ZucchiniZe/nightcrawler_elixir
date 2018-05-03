defmodule Nightcrawler.Marvel.Series do
  @moduledoc false
  @behaviour Nightcrawler.Marvel.Entity
  use Ecto.Schema
  import Ecto.Changeset

  import Ecto.Query, only: [from: 2]
  alias Nightcrawler.Marvel.Comic

  schema "series" do
    field :description, :string
    field :end_year, :integer
    field :modified, :utc_datetime
    field :rating, :string
    field :start_year, :integer
    field :title, :string

    embeds_one :thumbnail, Nightcrawler.Marvel.Common.Image

    has_many :comics, Nightcrawler.Marvel.Comic
    many_to_many :events, Nightcrawler.Marvel.Event, join_through: "series_events"
    many_to_many :creators, Nightcrawler.Marvel.Creator, join_through: "series_creators"
    many_to_many :characters, Nightcrawler.Marvel.Character, join_through: "series_characters"

    timestamps()
  end

  @doc false
  def changeset(series, attrs) do
    series
    |> cast(attrs, [:title, :id, :description, :start_year, :end_year, :modified, :rating])
    |> validate_required([:title, :id, :start_year, :end_year])
    |> cast_embed(:thumbnail)
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
      key in ~w(startYear endYear)a and v != nil ->
        underscored = Macro.underscore(k) |> String.to_atom()

        Map.put(acc, underscored, v)

      # normalize the rating because each one has like 4 fucking permutations of each
      key == :rating ->
        rating = parse_rating(v)

        Map.put(acc, key, rating)

      key in ~w(title description id thumbnail)a ->
        Map.put(acc, key, v)

      true ->
        acc
    end
  end

  def parse_rating(rating) do
    cond do
      rating in ["ALL AGES", "All Ages", "PG"] ->
        "All Ages"

      rating in [
        "RATED T",
        "Rated T",
        "T",
        "RATED A",
        "Rated a",
        "Rated A",
        "A",
        "MARVEL PSR",
        "Marvel Psr",
        "Parental Guidance",
        "PARENTAL SUPERVISION"
      ] ->
        "T"

      rating in [
        "RATED T+",
        "Rated T+",
        "T+",
        "13 & Up",
        "AGES 12 & UP",
        "MARVEL AGE (12+)",
        "MARVEL PSR+"
      ] ->
        "T+"

      rating in [
        "Parental Advisory",
        "PARENTAL ADVISORY",
        "PARENTAL ADVISORYSLC",
        "PARENTAL ADVISORY/EXPLICIT CONTENT",
        "Parental Advisory/Explicit Content",
        "Parental Advisoryslc"
      ] ->
        "Parental Advisory"

      rating in [
        "Mature",
        "EXPLICIT CONTENT",
        "Explicit Content",
        "MAX: EXPLICIT CONTENT",
        "Max: Explicit Content",
        "17 AND UP",
        "17 & UP"
      ] ->
        "Max: Explicit Content"

      rating in [
        "NO RATING",
        "No Rating",
        "NOT IN ORACLE",
        "Not in Oracle",
        " "
      ] ->
        "No Rating"

      true ->
        rating
    end
  end

  # queries

  @doc """
  Returns an `Ecto.Query` listing all of the series without any comics attached to them
  """
  def with_no_comics do
    from series in __MODULE__,
      left_join: c in Comic,
      on: [series_id: series.id],
      where: is_nil(c.series_id)
  end
end

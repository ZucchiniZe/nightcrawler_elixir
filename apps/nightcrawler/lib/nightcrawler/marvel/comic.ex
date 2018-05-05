defmodule Nightcrawler.Marvel.Comic do
  @moduledoc false
  @behaviour Nightcrawler.Marvel.Entity
  use Ecto.Schema
  import Ecto.Changeset
  alias Nightcrawler.Parser

  schema "comics" do
    field(:description, :string)
    field(:format, :string)
    field(:isbn, :string)
    field(:issue_number, :float)
    field(:modified, :utc_datetime)
    field(:page_count, :integer)
    field(:reader_id, :integer)
    field(:title, :string)

    embeds_one(:thumbnail, Nightcrawler.Marvel.Common.Image)
    belongs_to(:series, Nightcrawler.Marvel.Series)

    timestamps()
  end

  def changeset(attrs), do: changeset(%__MODULE__{}, attrs)

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
      :page_count,
      :series_id
    ])
    |> cast_embed(:thumbnail)
    |> validate_required([:title, :id])
    |> foreign_key_constraint(:series_id)
  end

  def transform do
    %{
      id: &Parser.integer_or_string/1,
      title: &Parser.integer_or_string/1,
      digitalId: &transform_digital_id/1,
      issueNumber: &Parser.underscore_key/1,
      description: &Parser.integer_or_string/1,
      pageCount: &Parser.underscore_key/1,
      series: &transform_series_id/1,
      format: &Parser.integer_or_string/1,
      isbn: &Parser.integer_or_string/1,
      modified: &Parser.maybe_datetime/1,
      thumbnail: &Parser.thumbnail/1
    }
  end

  defp transform_series_id({_key, val}) do
    %{id: id} = Parser.api_url(val["resourceURI"])
    {:series_id, id}
  end

  defp transform_digital_id({_key, val}), do: {:reader_id, val}
end

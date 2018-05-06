defmodule Nightcrawler.Marvel.Creator do
  @moduledoc false
  @behaviour Nightcrawler.Marvel.Entity
  use Ecto.Schema
  import Ecto.Changeset
  alias Nightcrawler.Parser

  schema "creators" do
    field(:first_name, :string)
    field(:full_name, :string)
    field(:last_name, :string)
    field(:middle_name, :string)
    field(:modified, :utc_datetime)
    field(:suffix, :string)

    embeds_one(:thumbnail, Nightcrawler.Marvel.Common.Image)
    many_to_many(:series, Nightcrawler.Marvel.Series, join_through: "series_creators")

    timestamps()
  end

  def changeset(attrs), do: changeset(%__MODULE__{}, attrs)

  def changeset(creator, attrs) do
    creator
    |> cast(attrs, [:first_name, :middle_name, :last_name, :suffix, :full_name, :id, :modified])
    |> cast_embed(:thumbnail)
    |> validate_required([:full_name, :id])
  end

  def transform do
    %{
      id: &Parser.integer_or_string/1,
      fullName: &Parser.underscore_key/1,
      firstName: &Parser.underscore_key/1,
      middleName: &Parser.underscore_key/1,
      lastName: &Parser.underscore_key/1,
      suffix: &Parser.integer_or_string/1,
      modified: &Parser.maybe_datetime/1,
      thumbnail: &Parser.thumbnail/1
    }
  end
end

defmodule Nightcrawler.Marvel.Creator do
  @moduledoc false
  @behaviour Nightcrawler.Marvel.Entity
  use Ecto.Schema
  import Ecto.Changeset


  schema "creators" do
    field :first_name, :string
    field :full_name, :string
    field :last_name, :string
    field :middle_name, :string
    field :modified, :utc_datetime
    field :suffix, :string

    embeds_one :thumbnail, Nightcrawler.Marvel.Common.Image
    many_to_many :series, Nightcrawler.Marvel.Series, join_through: "series_creators"

    timestamps()
  end

  @doc false
  def changeset(creator, attrs) do
    creator
    |> cast(attrs, [:first_name, :middle_name, :last_name, :suffix, :full_name, :id, :modified])
    |> cast_embed(:thumbnail)
    |> validate_required([:full_name, :id])
  end

  def api_to_changeset(data) do
    attrs =
      data
      |> Enum.reduce(%{}, &parse_values/2)
      |> Map.new()

    changeset(%__MODULE__{}, attrs)
  end

  def parse_values({k, v}, acc) do
    key = String.to_atom(k)

    cond do
      key == :modified ->
        case DateTime.from_iso8601(v) do
          {:ok, datetime, _} ->
            Map.put(acc, key, datetime)
          {:error, _} ->
            acc
        end

      # creator FIRM 15 breaks this because their last name is a number -_-
      key in ~w(lastName suffix)a and is_integer(v) ->
        underscored = Macro.underscore(k) |> String.to_atom()

        Map.put(acc, underscored, Integer.to_string(v))

      key in ~w(firstName middleName lastName fullName)a and v != nil ->
        underscored = Macro.underscore(k) |> String.to_atom()

        Map.put(acc, underscored, v)

      key in ~w(id suffix thumbnail)a ->
        Map.put(acc, key, v)

      true ->
        acc
    end
  end
end

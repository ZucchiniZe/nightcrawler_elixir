defmodule Nightcrawler.Marvel.Series do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset


  schema "series" do
    field :description, :string
    field :end_year, :integer
    field :marvel_id, :integer
    field :modified, :utc_datetime
    field :rating, :string
    field :start_year, :integer
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(series, attrs) do
    series
    |> cast(attrs, [:title, :marvel_id, :description, :start_year, :end_year, :modified, :rating])
    |> validate_required([:title, :marvel_id, :description, :start_year, :end_year, :modified, :rating])
  end
end
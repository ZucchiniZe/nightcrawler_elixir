defmodule Nightcrawler.Marvel.Character do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset


  schema "characters" do
    field :description, :string
    field :marvel_id, :id
    field :modified, :utc_datetime
    field :name, :string

    many_to_many :comics, Nightcrawler.Marvel.Comic, join_through: "comics_characters"

    timestamps()
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [:name, :marvel_id, :description, :modified])
    |> validate_required([:name, :marvel_id, :description, :modified])
  end
end

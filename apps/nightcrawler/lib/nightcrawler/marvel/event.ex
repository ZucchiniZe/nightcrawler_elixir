defmodule Nightcrawler.Marvel.Event do
  use Ecto.Schema
  import Ecto.Changeset


  schema "events" do
    field :description, :string
    field :end, :date
    field :marvel_id, :id
    field :modified, :utc_datetime
    field :start, :date
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title, :description, :marvel_id, :start, :end, :modified])
    |> validate_required([:title, :description, :marvel_id, :start, :end, :modified])
  end
end

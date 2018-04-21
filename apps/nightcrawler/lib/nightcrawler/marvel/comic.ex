defmodule Nightcrawler.Marvel.Comic do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset


  schema "comics" do
    field :description, :string
    field :format, :string
    field :isbn, :string
    field :issue_number, :integer
    field :marvel_id, :integer
    field :modified, :utc_datetime
    field :page_count, :integer
    field :reader_id, :integer
    field :title, :string

    belongs_to :series, Nightcrawler.Marvel.Series

    timestamps()
  end

  @doc false
  def changeset(comic, attrs) do
    comic
    |> cast(attrs, [:title, :reader_id, :marvel_id, :issue_number, :modified, :description, :isbn, :format, :page_count])
    |> validate_required([:title, :marvel_id, :issue_number, :description])
  end
end

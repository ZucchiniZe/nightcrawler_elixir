defmodule Nightcrawler.Marvel.Creator do
  use Ecto.Schema
  import Ecto.Changeset


  schema "creators" do
    field :first_name, :string
    field :full_name, :string
    field :last_name, :string
    field :marvel_id, :id
    field :middle_name, :string
    field :modified, :utc_datetime
    field :suffix, :string

    timestamps()
  end

  @doc false
  def changeset(creator, attrs) do
    creator
    |> cast(attrs, [:first_name, :middle_name, :last_name, :suffix, :full_name, :marvel_id, :modified])
    |> validate_required([:first_name, :middle_name, :last_name, :suffix, :full_name, :marvel_id, :modified])
  end
end

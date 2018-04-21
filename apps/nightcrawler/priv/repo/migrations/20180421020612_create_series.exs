defmodule Nightcrawler.Repo.Migrations.CreateSeries do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:series) do
      add :title, :string
      add :marvel_id, :id
      add :description, :text
      add :start_year, :integer
      add :end_year, :integer
      add :modified, :utc_datetime
      add :rating, :string

      timestamps()
    end

    create index(:series, [:marvel_id], unique: true)
  end
end

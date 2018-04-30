defmodule Nightcrawler.Repo.Migrations.AddSeriesRelations do
  use Ecto.Migration

  def change do
    create table(:series_creators) do
      add :series_id, references(:series)
      add :creator_id, references(:creators)
    end

    create table(:series_characters) do
      add :series_id, references(:series)
      add :character_id, references(:characters)
    end

    create table(:series_events) do
      add :series_id, references(:series)
      add :event_id, references(:events)
    end

    create unique_index(:series_creators, [:series_id, :creator_id])
    create unique_index(:series_characters, [:series_id, :character_id])
    create unique_index(:series_events, [:series_id, :event_id])
  end
end

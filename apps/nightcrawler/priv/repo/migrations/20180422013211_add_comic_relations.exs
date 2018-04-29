defmodule Nightcrawler.Repo.Migrations.AddComicRelations do
  use Ecto.Migration

  def change do
    create table(:comics_creators) do
      add :comic_id, references(:comics)
      add :creator_id, references(:creators)
    end

    create table(:comics_characters) do
      add :comic_id, references(:comics)
      add :character_id, references(:characters)
    end

    create table(:comics_events) do
      add :comic_id, references(:comics)
      add :event_id, references(:events)
    end

    create unique_index(:comics_creators, [:comic_id, :creator_id])
    create unique_index(:comics_characters, [:comic_id, :character_id])
    create unique_index(:comics_events, [:comic_id, :event_id])
  end
end

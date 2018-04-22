defmodule Nightcrawler.Repo.Migrations.AddComicsEvents do
  use Ecto.Migration

  def change do
    create table(:comics_events) do
      add :comic_id, references(:comics)
      add :event_id, references(:events)
    end

    create unique_index(:comics_events, [:comic_id, :event_id])
  end
end

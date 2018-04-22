defmodule Nightcrawler.Repo.Migrations.AddComicsCharacters do
  use Ecto.Migration

  def change do
    create table(:comics_characters) do
      add :comic_id, references(:comics)
      add :character_id, references(:characters)
    end

    create unique_index(:comics_characters, [:comic_id, :character_id])
  end
end

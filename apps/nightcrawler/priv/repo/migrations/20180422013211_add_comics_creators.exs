defmodule Nightcrawler.Repo.Migrations.AddComicsCreators do
  use Ecto.Migration

  def change do
    create table(:comics_creators) do
      add :comic_id, references(:comics)
      add :creator_id, references(:creators)
    end

    create unique_index(:comics_creators, [:comic_id, :creator_id])
  end
end

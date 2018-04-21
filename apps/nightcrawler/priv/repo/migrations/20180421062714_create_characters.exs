defmodule Nightcrawler.Repo.Migrations.CreateCharacters do
  use Ecto.Migration

  def change do
    create table(:characters) do
      add :name, :string
      add :marvel_id, :id
      add :description, :text
      add :modified, :utc_datetime

      timestamps()
    end

    create index(:characters, [:marvel_id], unique: true)
  end
end

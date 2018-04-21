defmodule Nightcrawler.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string
      add :description, :text
      add :marvel_id, :id
      add :start, :date
      add :end, :date
      add :modified, :utc_datetime

      timestamps()
    end

    create index(:events, [:marvel_id], unique: true)
  end
end

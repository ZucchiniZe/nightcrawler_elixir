defmodule Nightcrawler.Repo.Migrations.CreateEvents do
  @moduledoc false
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

    create unique_index :events, [:marvel_id]
  end
end

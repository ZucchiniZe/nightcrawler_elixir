defmodule Nightcrawler.Repo.Migrations.CreateCreators do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:creators) do
      add :first_name, :string
      add :middle_name, :string
      add :last_name, :string
      add :suffix, :string
      add :full_name, :string
      add :marvel_id, :id
      add :modified, :utc_datetime

      timestamps()
    end

    create unique_index :creators, [:marvel_id]
  end
end

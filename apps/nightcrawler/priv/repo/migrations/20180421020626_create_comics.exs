defmodule Nightcrawler.Repo.Migrations.CreateComics do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:comics) do
      add :title, :string
      add :reader_id, :integer
      add :marvel_id, :integer
      add :issue_number, :integer
      add :modified, :utc_datetime
      add :description, :text
      add :isbn, :string
      add :format, :string
      add :page_count, :integer
      add :series_id, references(:series, on_delete: :nothing)

      timestamps()
    end

    create index(:comics, [:series_id])
  end
end

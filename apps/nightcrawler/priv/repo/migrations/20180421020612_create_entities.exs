defmodule Nightcrawler.Repo.Migrations.CreateEntities do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:series) do
      add :title, :string
      add :description, :text
      add :start_year, :integer
      add :end_year, :integer
      add :rating, :string
      add :modified, :utc_datetime

      add :thumbnail, :jsonb, default: "[]"

      timestamps()
    end

    create table(:comics) do
      add :title, :string
      add :description, :text
      add :reader_id, :integer
      add :issue_number, :integer
      add :isbn, :string
      add :format, :string
      add :page_count, :integer
      add :modified, :utc_datetime

      add :thumbnail, :jsonb, default: "[]"

      timestamps()
    end

    create table(:creators) do
      add :first_name, :string
      add :middle_name, :string
      add :last_name, :string
      add :suffix, :string
      add :full_name, :string
      add :modified, :utc_datetime

      add :thumbnail, :jsonb, default: "[]"

      timestamps()
    end

    create table(:characters) do
      add :name, :string
      add :description, :text
      add :modified, :utc_datetime

      add :thumbnail, :jsonb, default: "[]"

      timestamps()
    end

    create table(:events) do
      add :title, :string
      add :description, :text
      add :start, :date
      add :end, :date
      add :modified, :utc_datetime

      add :thumbnail, :jsonb, default: "[]"

      timestamps()
    end

    create table(:stories) do
      add :title, :string
      add :description, :string
      add :type, :string
      add :modified, :utc_datetime

      add :thumbnail, :jsonb, default: "[]"

      timestamps()
    end
  end
end

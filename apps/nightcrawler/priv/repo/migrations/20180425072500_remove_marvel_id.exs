defmodule Nightcrawler.Repo.Migrations.RemoveMarvelId do
  use Ecto.Migration

  def change do
    alter table(:series), do: remove :marvel_id
    alter table(:comics), do: remove :marvel_id
    alter table(:creators), do: remove :marvel_id
    alter table(:characters), do: remove :marvel_id
    alter table(:events), do: remove :marvel_id
  end
end

defmodule BadDate.Repo.Migrations.AddPausedToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :paused, :boolean, default: false, null: false
    end
  end
end

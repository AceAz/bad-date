defmodule BadDate.Repo.Migrations.CreateBlocks do
  use Ecto.Migration

  def change do
    create table(:blocks) do
      add :blocker_id, references(:users, on_delete: :delete_all)
      add :blocked_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:blocks, [:blocker_id, :blocked_id], name: :unique_block)
  end
end


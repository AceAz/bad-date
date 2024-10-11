defmodule BadDate.Repo.Migrations.AddUserProfileFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :location, :string
      add :hobbies, :text  # You can store hobbies as a list or a single text field
      add :favorite_food, :string
      add :description, :text  # A general description about the user
    end
  end
end

defmodule BadDate.Accounts.Block do
  use Ecto.Schema
  import Ecto.Changeset

  schema "blocks" do
    field :blocker_id, :id
    field :blocked_id, :id

    timestamps()
  end

  def changeset(block, attrs) do
    block
    |> cast(attrs, [:blocker_id, :blocked_id])
    |> validate_required([:blocker_id, :blocked_id])
  end
end


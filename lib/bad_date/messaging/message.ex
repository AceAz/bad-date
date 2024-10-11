defmodule BadDate.Messaging.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :string
    belongs_to :sender, BadDate.Accounts.User, foreign_key: :sender_id
    belongs_to :recipient, BadDate.Accounts.User, foreign_key: :recipient_id

    timestamps()
  end

  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :sender_id, :recipient_id])
    |> validate_required([:content, :sender_id, :recipient_id])
  end
end


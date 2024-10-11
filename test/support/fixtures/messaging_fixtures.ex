defmodule BadDate.MessagingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BadDate.Messaging` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        content: "some content"
      })
      |> BadDate.Messaging.create_message()

    message
  end
end

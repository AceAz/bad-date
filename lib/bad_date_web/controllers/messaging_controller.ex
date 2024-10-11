defmodule BadDateWeb.MessagingController do
  use BadDateWeb, :controller
  alias BadDate.Messaging
  alias BadDate.Messaging.Message
  alias BadDate.Accounts
 

 # List all messages
  def index(conn, _params) do
  user = conn.assigns[:current_user]

  if user do
    messages = Messaging.list_user_messages(user.id)
    render(conn, "index.html", messages: messages)
  else
    conn
    |> put_flash(:error, "You need to log in to view your messages.")
    |> redirect(to: ~p"/users/log_in")
  end
end


  # Display the form for a new message
  def new(conn, _params) do
    changeset = Messaging.change_message(%Message{})
    render(conn, "new.html", changeset: changeset)
  end

  # Create a new message and handle the logic for sending it
  def create(conn, %{"message" => %{"recipient_id" => recipient_email, "content" => content}}) do
    user = conn.assigns[:current_user]

    # Look up recipient by email
    recipient = Accounts.get_user_by_email(recipient_email)

    if recipient do
      # Check if the sender is blocked by the recipient
      if Accounts.is_blocked?(user.id, recipient.id) do
        conn
        |> put_flash(:error, "You are blocked from messaging this user.")
        |> redirect(to: ~p"/messages/new")
      else
       # Prepare message parameters
        message_params = %{
          "sender_id" => user.id,
          "recipient_id" => recipient.id,
          "content" => content
      }

      case Messaging.create_message(message_params) do
        {:ok, _message} ->
          conn
          |> put_flash(:info, "Message sent successfully.")
          |> redirect(to: ~p"/messages")

        {:error, changeset} ->
          render(conn, "new.html", changeset: changeset)
       end
      end
    else
      conn
      |> put_flash(:error, "Recipient not found.")
      |> redirect(to: ~p"/messages/new")
    end
  end
end


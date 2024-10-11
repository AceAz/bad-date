defmodule BadDateWeb.ProfileController do
  use BadDateWeb, :controller
  alias BadDate.Accounts

  # Show the profile page for a user by ID
  def show(conn, %{"id" => id}) do
  case Integer.parse(id) do
    {int_id, _} -> 
      user = Accounts.get_user!(int_id)  # Fetch the user by integer ID
      render(conn, BadDateWeb.ProfileHTML, "show.html", user: user)

    :error ->
      conn
       |> redirect(to: "/profile")
  end
 end     
  # Display the current user's profile
  def index(conn, _params) do
    user = conn.assigns[:current_user]
    render(conn, BadDateWeb.ProfileHTML, "show.html", user: user)
  end

  def new(conn, _params) do
    user = conn.assigns[:current_user]
    changeset = Accounts.change_user_profile(user)
    render(conn, BadDateWeb.ProfileHTML, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => profile_params}) do
    user = conn.assigns[:current_user]

    case Accounts.update_user_profile(user, profile_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Profile created successfully!")
        |> redirect(to: ~p"/profile/#{user.id}")
      {:error, changeset} ->
        render(conn, BadDateWeb.ProfileHTML, "new.html", changeset: changeset)
    end
  end

  def edit(conn, _params) do
    user = conn.assigns[:current_user]
    changeset = Accounts.change_user_profile(user)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"user" => profile_params}) do
    user = conn.assigns[:current_user]

    case Accounts.update_user_profile(user, profile_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Profile updated successfully!")
        |> redirect(to: ~p"/profile/#{user.id}")
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end
end

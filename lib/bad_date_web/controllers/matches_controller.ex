defmodule BadDateWeb.MatchesController do
  use BadDateWeb, :controller
  alias BadDate.Accounts

  def show(conn, _params) do
    user = conn.assigns[:current_user]
    worst_match = Accounts.find_worst_match(user)

    case worst_match do
      nil ->
        conn
        |> put_flash(:info, "No worst match found.")
        |> render(BadDateWeb.MatchesHTML, "show.html", user: user, worst_match: nil)
      
      _match ->
        render(conn, BadDateWeb.MatchesHTML, "show.html", user: user, worst_match: worst_match)
    end
  end
end

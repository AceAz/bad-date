defmodule BadDateWeb.MessagingHTML do
  alias BadDateWeb.Router.Helpers, as: Routes

  use BadDateWeb, :html

  import Phoenix.HTML.Form  # This will make the form helpers available

  # This will look for templates in the "messaging" folder
  embed_templates "messaging/*"
end

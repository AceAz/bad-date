defmodule BadDateWeb.BlockHTML do
  use BadDateWeb, :html
  
  import Phoenix.HTML

 
  embed_templates "blocked_html/*"

end


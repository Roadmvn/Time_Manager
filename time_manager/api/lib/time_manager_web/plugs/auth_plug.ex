defmodule TimeManagerWeb.AuthPlug do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    # Ici, vous devriez implémenter la logique d'authentification réelle
    # Pour l'instant, nous allons simplement laisser passer toutes les requêtes
    conn
  end
end

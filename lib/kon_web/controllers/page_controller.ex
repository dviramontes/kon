defmodule KonWeb.PageController do
  use KonWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

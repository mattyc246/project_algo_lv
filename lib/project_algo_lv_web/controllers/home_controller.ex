defmodule ProjectAlgoLvWeb.HomeController do
  use ProjectAlgoLvWeb, :controller

  def index(conn, _params) do
    conn
    |> render("home.html")
  end
end
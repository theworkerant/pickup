defmodule PickupWeb.SessionController do
  use PickupWeb, :controller

  alias Pickup.{User, Users, Guardian}

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/login")
  end

  def new(conn, _) do
    conn
    |> render("new.html", return_to: get_session(conn, "return_to"))
  end
end

defmodule PickupWeb.PageLive do
  use PickupWeb, :live_view

  alias Pickup.{Users}

  def mount(_params, session, socket) do
    socket = socket
    |> put_flash(:info, "user created")

    {:ok, assign(socket, current_user: Users.get!(session["current_user_id"]))}
  end

  #
  # def handle_event("suggest", %{"q" => query}, socket) do
  #   {:noreply, assign(socket, results: search(query), query: query)}
  # end
end

defmodule PickupWeb.MatchesLive do
  use PickupWeb, :live_view

  alias Pickup.{Users}

  def mount(params, session, socket) do
    IO.inspect(params)
    {:ok, assign(socket, current_user: Users.get!(session["current_user_id"]))}
  end

  def handle_params(params, uri, socket) do
    IO.inspect(uri)
    {:noreply, socket}
  end
end

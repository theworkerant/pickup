defmodule PickupWeb.NewMatchLive do
  use PickupWeb, :live_view

  alias Pickup.{Users}

  def mount(params, session, socket) do
    {:ok, assign(socket, current_user: Users.get!(session["current_user_id"]))}
  end

  def handle_params(params, uri, socket) do
    {:noreply, socket}
  end
end

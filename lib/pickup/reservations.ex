defmodule Pickup.Reservations do
  use Ecto.Schema

  import Ecto.{Query}

  alias Pickup.{Repo, Reservation}

  def get(match_id, user_id) do
    from(r in Reservation, where: r.match_id == ^match_id and r.user_id == ^user_id)
    |> Repo.one()
  end

  def create(reservation_attrs) do
    Reservation.changeset(%Reservation{}, reservation_attrs) |> Repo.insert()
  end

  def update(reservation, reservation_attrs) do
    Reservation.changeset(reservation, reservation_attrs) |> Repo.update()
  end

  def destroy(match_id, user_id) do
    get(match_id, user_id)
    |> case do
      nil -> :noop
      reservation -> Repo.delete(reservation)
    end
  end
end

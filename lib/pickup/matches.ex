defmodule Pickup.Matches do
  use Ecto.Schema

  import Ecto.{Query}

  alias Pickup.{Repo, Match, Reservation, Reservations}

  def reservations(%Match{} = match), do: reservations(match.id)

  def reservations(id) do
    from(r in Reservation, where: r.match_id == ^id) |> Repo.all()
  end

  def players(%Match{} = match), do: players(match.id)

  def players(id) do
    from(r in Reservation, where: r.match_id == ^id and not r.standby, preload: :user)
    |> Repo.all()
  end

  def standbys(%Match{} = match), do: standbys(match.id)

  def standbys(id) do
    from(r in Reservation, where: r.match_id == ^id and r.standby, preload: :user)
    |> Repo.all()
  end

  def count do
    Repo.aggregate(from(m in Match), :count, :id)
  end

  def create(match_attrs) do
    name = Match.generate_name(count())
    host_reservation = %{user_id: match_attrs.host_id, standby: false}

    Match.changeset(%Match{name: name, reservations: [host_reservation]}, match_attrs)
    |> Repo.insert()
  end

  def get(id) do
    from(m in Match, where: m.id == ^id, preload: :reservations) |> Repo.one()
  end

  def slots_remaining(%Match{} = match) do
    match.slots - length(players(match.id))
  end

  def slots_remaining(id), do: id |> get() |> slots_remaining()

  def reserve(%Match{} = match, user_id) do
    if slots_remaining(match) > 0 do
      existing = Reservations.get(match.id, user_id)

      case existing do
        nil -> Reservations.create(%{user_id: user_id, match_id: match.id})
        %{standby: true} -> Reservations.update(existing, %{standby: false})
        _ -> :noop
      end
    else
      Reservations.create(%{user_id: user_id, match_id: match.id, standby: true})
    end
  end

  def reserve(match_id, user_id), do: reserve(get(match_id), user_id)

  def standby(user_id, %Match{} = match) do
    Reservations.create(%{user_id: user_id, match_id: match.id, standby: true})
  end

  def standby(match_id, user_id), do: standby(get(match_id), user_id)

  def relinquish(match_id, user_id), do: Reservations.destroy(match_id, user_id)
end

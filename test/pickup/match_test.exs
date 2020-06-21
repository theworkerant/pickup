defmodule Pickup.MatchTest do
  use PickupWeb.ConnCase

  alias Pickup.{Repo, Match, Matches, Game, User}

  doctest Match

  test "Match setup" do
    {:ok, game} = %Game{name: "Dodgeball"} |> Repo.insert()

    {:ok, kate} = %User{name: "kate"} |> Repo.insert()
    {:ok, white} = %User{name: "white"} |> Repo.insert()
    {:ok, vince} = %User{name: "vince"} |> Repo.insert()
    {:ok, justin} = %User{name: "justin"} |> Repo.insert()

    start = NaiveDateTime.utc_now()

    {:ok, match} =
      Matches.create(%{game_id: game.id, host_id: kate.id, slots: 2, start: start, duration: 60})

    # Kate joins automagically
    assert Matches.slots_remaining(match.id) == 1
    Matches.reserve(match, kate.id)
    # But she can't join twice
    assert Matches.slots_remaining(match.id) == 1

    Matches.reserve(match, white.id)
    assert length(Matches.reservations(match.id)) == 2
    assert Matches.slots_remaining(match.id) == 0

    Matches.relinquish(match.id, kate.id)
    assert Matches.slots_remaining(match.id) == 1
    # relinquishing twice doesn't explode
    Matches.relinquish(match.id, kate.id)
    assert Matches.slots_remaining(match.id) == 1

    Matches.reserve(match, vince.id)
    assert Matches.slots_remaining(match.id) == 0

    # re-reserving doesn't change status
    Matches.reserve(match, vince.id)
    assert length(Matches.standbys(match)) == 0
    assert Matches.slots_remaining(match.id) == 0

    # Ringer logic
    assert length(Matches.standbys(match)) == 0
    Matches.reserve(match, justin.id)
    assert Matches.slots_remaining(match.id) == 0
    assert length(Matches.standbys(match)) == 1

    Matches.relinquish(match.id, vince.id)
    # relinquish does not automatically slot standbys
    assert length(Matches.standbys(match)) == 1
    assert Matches.slots_remaining(match.id) == 1
    Matches.reserve(match, justin.id)
    assert length(Matches.standbys(match)) == 0
    assert Matches.slots_remaining(match.id) == 0
  end
end

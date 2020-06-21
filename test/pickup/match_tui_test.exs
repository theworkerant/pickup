defmodule Pickup.MatchTuiTest do
  use Pickup.DataCase

  alias Pickup.{MatchTui}

  test "players row" do
    players = ["Ensy", "Ergle", "Nebuchadnezzar The First"]

    players_row = MatchTui.players_row(players)

    assert players_row == "┋      Ensy     ┋     Ergle     ┋ Nebuchadnezz… ┋"
  end

  test "players row with nils" do
    players_row = MatchTui.players_row(["Ensy", nil, "Ergle"])
    assert players_row == "┋      Ensy     ┋   - open -    ┋     Ergle     ┋"

    players_row = MatchTui.players_row(["Ensy", "Ergle", nil])
    assert players_row == "┋      Ensy     ┋     Ergle     ┋    - open -    "

    players_row = MatchTui.players_row(["Ensy", nil, nil])
    assert players_row == "┋      Ensy     ┋   - open -         - open -    "

    players_row = MatchTui.players_row([nil, nil, nil])
    assert players_row == "    - open -        - open -         - open -    "
  end
end

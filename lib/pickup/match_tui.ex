defmodule Pickup.MatchTui do
  alias Pickup.{Draw}

  def ui(slots) do
    player_rows(slots)
  end

  def player_rows(slots) do
    slots
    |> Enum.chunk_by(3)
    |> Enum.map(fn cols ->
      players_row(cols)
    end)
  end

  def players_row(names) do
    names
    |> Enum.with_index()
    |> Enum.map(fn {name, index} ->
      last = index == length(names) - 1
      size = if last, do: 17, else: 16

      if name do
        suffix = if last, do: "┋", else: ""

        name
        |> Draw.fitted(size - 4)
        |> Draw.center(size, prefix: "┋ ", suffix: suffix)
      else
        preceeded_by_player = Enum.at(names, index - 1)
        prefix = if preceeded_by_player, do: "┋", else: " "

        Draw.center("- open -", size, prefix: prefix)
      end
    end)
    |> Enum.join("")
  end
end

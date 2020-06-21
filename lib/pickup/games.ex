defmodule Pickup.Games do
  use Ecto.Schema

  alias Pickup.{Game, Repo}

  import Ecto.{Query}

  def upsert(attrs) do
    game = from(g in Game, where: g.slug == ^attrs.slug) |> Repo.one()

    case game do
      {:ok, game} ->
        game
        |> Game.changeset(attrs)
        |> Repo.update()

      nil ->
        %Game{}
        |> Game.changeset(attrs)
        |> Repo.insert()
    end
  end
end

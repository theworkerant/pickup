# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pickup.Repo.insert!(%Pickup.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

tf2_desc = ~s"""
Casual / Comp / TF2Center / MGE / Ulti-Duo / Scrims

Optional warmup 20 minutes before start time

Server info: < reserve ahead with https://na.serveme.tf/ for free server >
[Useful Server Commands](https://wiki.teamfortress.com/wiki/List_of_useful_console_commands#mp_commands)
"""

drg_desc = ~s"""
Deep Dive / Casual
"""

reflex_desc = ~s"""
FFA / Teams / Game Modifiers?
"""

[
  %{
    name: "Deep Rock Galactic",
    slug: "drg",
    defaults: %{
      slots: 4,
      max: 4,
      description: drg_desc
    }
  },
  %{
    name: "Team Fortress 2",
    slug: "tf2",
    defaults: %{
      slots: 6,
      max: 24,
      description: tf2_desc
    }
  },
  %{
    name: "Reflex Arena",
    slug: "reflex",
    defaults: %{
      slots: 2,
      max: 10,
      description: reflex_desc
    }
  },
  %{
    name: "Go",
    slug: "go",
    defaults: %{
      slots: 2,
      max: 10,
      description: ""
    }
  }
]
|> Enum.map(&Pickup.Games.upsert(&1))

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

tf2_desc= %Q(
Casual / Comp / TF2Center / MGE / Ulti-Duo / Scrims

Optional warmup 20 minutes before start time

Server info: < reserve ahead with https://na.serveme.tf/ for free server >
).strip

drg_desc= %Q(
Deep Dive / Casual
).strip

reflex_desc= %Q(
FFA / Teams / Game Modifiers?
).strip

[
  {
    name: "Deep Rock Galactic",
    slug: "drg",
    defaults: {
      slots: 4,
      max: 4,
      description: drg_desc
    }
  },
  {
    name: "Team Fortress 2",
    slug: "tf2",
    defaults: {
      slots: 6,
      max: 24,
      description: tf2_desc
    }
  },
  {
    name: "Reflex Arena",
    slug: "reflex",
    defaults: {
      slots: 2,
      max: 10,
      description: reflex_desc
    }
  },
  {
    name: "Go",
    slug: "go",
    defaults: {
      slots: 2,
      max: 10,
      description: ""
    }
  }
].each do |game|
  Game.create(game)
end

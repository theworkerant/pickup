# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


[
  ["Deep Rock Galactic", "drg", {slots: 4, max: 4}],
  ["Team Fortress 2", "tf2", {slots: 6, max: 24}],
  ["Reflex Arena", "reflex", {slots: 2, max: 10}]
].each do |(game,slug,defaults)|
  Game.create(name: game, slug: slug, defaults: defaults)
end

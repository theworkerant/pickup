require "rails_helper"

RSpec.describe Match, type: :model do

  it "Generates names predictably" do
    game = Game.create(name: "Dodgeball")
    kate = User.create(username: "kate")
    match = Match.create(game: game, host: kate, slots: 2)
    match2 = Match.create(game: game, host: kate, slots: 2)

    # Should be the same each time
    expect(match.name).to eq("Amatory Setback")
    expect(match2.name).to eq("Judicious Disruption")
  end

  it "Match works" do
    game = Game.create(name: "Dodgeball")
    kate = User.create(username: "kate")
    white = User.create(username: "white")
    vince = User.create(username: "vince")
    justin = User.create(username: "justin")
    match = Match.create(game: game, host: kate, slots: 2)

    # Kate joins automagically
    expect(match.slots_remaining).to eq(1)
    match.reserve(kate)
    # But she can't join twice
    expect(match.slots_remaining).to eq(1)

    match.reserve(white)
    expect(match.reservations.count).to eq(2)
    expect(match.slots_remaining).to eq(0)

    match.relinquish(kate)
    expect(match.slots_remaining).to eq(1)
    # relinquishing twice doesn't explode
    match.relinquish(kate)
    expect(match.slots_remaining).to eq(1)

    match.reserve(vince)
    expect(match.slots_remaining).to eq(0)

    # re-reserving doesn't change status
    match.reserve(vince)
    expect(match.ringers.count).to eq(0)
    expect(match.slots_remaining).to eq(0)

    # Ringer logic
    expect(match.ringers.count).to eq(0)
    match.reserve(justin)
    expect(match.slots_remaining).to eq(0)
    expect(match.ringers.count).to eq(1)

    match.relinquish(vince)
    # relinquish does not automatically slot ringers
    expect(match.ringers.count).to eq(1)
    expect(match.slots_remaining).to eq(1)
    match.reserve(justin)
    expect(match.ringers.count).to eq(0)
    expect(match.slots_remaining).to eq(0)
  end
end

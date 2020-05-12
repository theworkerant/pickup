require "rails_helper"

RSpec.describe Match, type: :model do

  it "Match works" do
    game = Game.create(name: "Dodgeball")
    kate = User.create(username: "kate")
    white = User.create(username: "white")
    vince = User.create(username: "vince")
    match = Match.create(host: kate, slots: 2)

    # Kate joins automagically
    expect(match.slots_remaining).to eq(1)

    match.reserve(white)
    expect(match.slots_remaining).to eq(0)

    match.relinquish(kate)
    expect(match.slots_remaining).to eq(1)

    match.reserve(vince)
    expect(match.slots_remaining).to eq(0)
  end
end

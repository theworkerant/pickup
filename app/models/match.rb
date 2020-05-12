class Match < ApplicationRecord
  belongs_to :game
  belongs_to :host, class_name: "User", foreign_key: "user_id"

  has_many :reservations
  has_many :users, through: :reservations

  after_create :reserve_host

  def reserve(user)
    self.reservations.create(user: user)
  end

  def relinquish(user)
    self.reservations.where(user_id: user.id).first.destroy
  end

  def slots_remaining
    count = slots - users.count
    count < 0 ? 0 : count
  end

  def announce
    match = self
    embed = Discord::Embed.new do
      title("#{match.host.username} wants to play #{match.game.name}")
      description(match.description)
      author(name: match.host.username, icon_url: match.host.picture)
      add_field(name: "Slots", value: match.slots)
      add_field(name: "Start", value: match.start_time.strftime("%I:%M %p Eastern"))
      add_field(name: "End", value: (match.start_time + match.duration.minutes).strftime("%I:%M %p Eastern"))
      add_field(name: "Queue Up!", value: "[click to reserve](https://fathompickup.herokuapp.com)")
      image(url: ENV["HOST"] + ActionController::Base.helpers.asset_url("games/#{match.game.slug}.webp"))
      timestamp(DateTime.now)
      footer(text: "Fathom Pickup :: #{ENV['HOST']}")
    end

    Discord::Notifier.message(embed)
  end

  private

  def reserve_host
    self.reservations.create(user: host)
  end
end

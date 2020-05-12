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

  def formatted_start
    self.start_time.strftime("%I:%M %p")
  end
  def formatted_end
    (self.start_time + self.duration.minutes).strftime("%I:%M %p")
  end

  def formatted_time
    "#{formatted_start} / #{formatted_end} Eastern"
  end

  def announce
    match = self
    embed = Discord::Embed.new do
      title("#{match.host.username} wants to play #{match.game.name}")
      description(match.description)
      author(name: match.host.username, icon_url: match.host.picture)
      add_field(name: "Slots", value: "#{match.host.username} + **#{match.slots - 1} more**")
      add_field(name: "Time", value: match.formatted_time)
      add_field(name: "I'll Play!", value: "[click to reserve](https://fathompickup.herokuapp.com)")
      thumbnail(url: ENV["HOST_URL"] + ActionController::Base.helpers.asset_url("games/#{match.game.slug}.webp"))
      # image(url: ENV["HOST_URL"] + ActionController::Base.helpers.asset_url("games/#{match.game.slug}.webp"))
      timestamp(DateTime.now)
      footer(text: "pickup.fathom.digital")
    end

    Discord::Notifier.message(embed)
  end

  private

  def reserve_host
    self.reservations.create(user: host)
  end
end

class Match < ApplicationRecord
  belongs_to :game
  belongs_to :host, class_name: "User", foreign_key: "user_id"

  has_many :reservations
  has_many :users, through: :reservations

  after_create :reserve_host

  def reserve(user)
    begin
      self.reservations.create(user: user)
    rescue ActiveRecord::RecordNotUnique
      false
    end
  end

  def reserved?(user)
    self.reservations.where(user_id: user.id).present?
  end

  def relinquish(user)
    self.reservations.where(user_id: user.id).first&.destroy
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
      add_field(name: "Total Slots", value: "#{match.slots} slots")
      add_field(name: "Time", value: match.formatted_time)
      add_field(name: "I'll Play!", value: "[ click to reserve ](#{ENV['HOST_URL']}/matches/#{match.id}/reserve)")
      thumbnail(url: match.host.picture)
      image(url: match.image_url("games/#{match.game.slug}.webp"))
      timestamp(DateTime.now)
      footer(text: "pickup.fathom.digital")
    end

    Discord::Notifier.message(embed)
  end

  def image_url(name)
    ENV["HOST_URL"] + ActionController::Base.helpers.asset_url(name)
  end

  private

  def reserve_host

    self.reservations.create(user: self.host)
  end
end

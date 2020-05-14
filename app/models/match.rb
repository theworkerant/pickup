class Match < ApplicationRecord
  belongs_to :game
  belongs_to :host, class_name: "User", foreign_key: "user_id"

  has_many :reservations
  has_many :users, through: :reservations

  after_create :reserve_host

  def players
    reservations.includes(:user).where(ringer: false).map{|r| r.user}
  end

  def ringers
    reservations.includes(:user).where(ringer: true).map{|r| r.user}
  end

  def reserve(user)
    begin
      slot = reservations.find_or_initialize_by(user_id: user.id)
      slot.ringer = full? if slot.ringer || slot.new_record?
      notify = slot.ringer_changed? || slot.new_record?
      slot.save
      Notifications.player_reserved(self, user) if notify
    rescue ActiveRecord::RecordNotUnique
      false
    end
  end

  def full?
    players.count >= slots
  end

  def reserved?(user)
    reservations.where(user_id: user.id).present?
  end

  def ringer?(user)
    reservations.where(user_id: user.id, ringer: true).present?
  end

  def relinquish(user)
    reservations.where(user_id: user.id).first&.destroy
    Notifications.player_relinquished(self)
  end

  def slots_remaining
    slots - players.count
  end

  def formatted_start
    start_time.strftime("%I:%M %p")
  end

  def formatted_end
    (start_time + duration.minutes).strftime("%I:%M %p")
  end

  def formatted_time
    "#{formatted_start} / #{formatted_end} Eastern"
  end

  def reserve_url
    "#{ENV['HOST_URL']}/matches/#{id}/reserve"
  end

  def announce
    Notifications.announce_match(match)
    Notifications.announce_match(host, game.interested)
  end

  private

  def reserve_host
    reservations.create(user: self.host)
  end
end

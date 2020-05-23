class Match < ApplicationRecord
  belongs_to :game
  belongs_to :host, class_name: "User", foreign_key: "user_id"
  belongs_to :webhook

  has_many :reservations
  has_many :users, through: :reservations

  after_create :reserve_host
  before_create :generate_name

  DEFAULT_START = ActiveSupport::TimeZone["EST"].parse("#{Time.zone.now.to_date} 6pm")

  def to_param
    "#{id}-#{name.parameterize}"
  end

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
    start_time.strftime("%a %l:%M %p")
  end

  def formatted_end
    (start_time + duration.minutes).strftime("%l:%M %p")
  end

  def start_datetime
    day + start_time.seconds_since_midnight.seconds
  end

  def time_until_start
    remaining_seconds = (start_time - Time.zone.now)

    days = (remaining_seconds / 86400).floor
    hours = ((remaining_seconds - days * 86400) / 3600).floor
    minutes = ((remaining_seconds - days  * 86400 - hours * 3600) / 60).floor
    {days: days, hours: hours, minutes: minutes}
  end

  def formatted_time_until_start
    from_now = time_until_start.reduce([]) do |memo, (key,value)|
      memo << "#{value}#{key[0]}" if value > 0
      memo
    end.join(" ")
  end

  def formatted_time
    "#{formatted_start} / #{formatted_end} Eastern"
  end

  def formatted_time_until
     "starts in #{formatted_time_until_start}"
  end

  def reserve_url
    "#{ENV['HOST_URL']}/matches/#{id}/reserve"
  end

  def announce
    notifier.announce_match(self)
    notifier.mention_match_for_interested(host, game.interested)
  end

  private
  def notifier
    @notifier ||= Notifications.new(self.webhook)
  end

  def generate_name
    random = Random.new(1337)
    matches_count = Match.count
    self.name = [MATCH_ADJECTIVES, MATCH_NOUNS].reduce([]) do |memo, words|
      memo << words.shuffle(random: random)[matches_count]
    end.join(" ")
  end

  def reserve_host
    reservations.create(user: host)
  end

end

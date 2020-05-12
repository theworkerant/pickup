class Match < ApplicationRecord
  require "discordrb/webhooks"

  WEBHOOK_URL = "https://discordapp.com/api/webhooks/709567145465479260/W3oj1bj3uqsPzQo379WrnT0IAUsNBTK5IvVwzqGOIk4hGabWhB1ARbBsg1r3Vd9zuSU_".freeze

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
    client = Discordrb::Webhooks::Client.new(url: WEBHOOK_URL)

    client.execute do |builder|
      # builder.content = "Hello world!"
      builder.add_embed do |embed|
        embed.title = "Let's Play!"
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(
          name: self.host.username,
          icon_url: self.host.picture
        )
        embed.description = self.description
        embed.color = "#865cbb"
        embed.image = Discordrb::Webhooks::EmbedThumbnail.new(
          url: ENV["HOST"] + ActionController::Base.helpers.asset_url("games/#{self.game.slug}.webp")
        )
        embed.timestamp = Time.now
      end
    end
  end

  private

  def reserve_host
    self.reservations.create(user: host)
  end
end

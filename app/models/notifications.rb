class Notifications
  def self.player_reserved(match, player)
    if match.ringers.count > 0
      notify("<@#{player.uid}> wants to join but slots are full! They've been added as a possible ringer.")
    elsif match.slots_remaining == 0
      notify("
      <@#{player.uid}> just joined and the match is **now full**!! However! _You can still [join as a ringer](#{match.reserve_url})_ and you'll be notified if a slot opens up.
      ")
    else
      notify("<@#{player.uid}> just joined, **#{match.slots_remaining}** slots left.")
    end
  end

  def self.player_relinquished(match)
    if match.ringers.count > 0
      mentions = match.ringers.map do |ringer|
        "<@!#{ringer.uid}>"
      end.join(" ")

      notify("#{mentions} A slot is now available! [click to reserve](#{match.reserve_url})")
    end
  end

  def self.announce_match(match)
    image = image_url("games/#{match.game.slug}.webp")
    embed = Discord::Embed.new do
      title("#{match.host.username} wants to play #{match.game.name}")
      description(match.description)
      add_field(name: "Total Slots", value: "#{match.slots} slots")
      add_field(name: "Time", value: match.formatted_time)
      add_field(name: "I'll Play!", value: "[>> CLICK TO RESERVE <<](#{match.reserve_url})")
      thumbnail(url: match.host.picture)
      image(url: image)
      timestamp(DateTime.now)
      footer(text: "pickup.fathom.digital")
    end

    notify(embed)
  end

  def self.mention_match_for_interested(host, interested)
    mentions = (interested-[host]).map do |user|
      "<@!#{user.uid}>"
    end.join(" ")

    if interested.present?
      notify(":point_up: :point_up: :point_up: **Rally, soldiers!** #{mentions}")
    end
  end


  private
  def self.image_url(name)
    ENV["HOST_URL"] + ActionController::Base.helpers.asset_url(name)
  end

  def self.notify(message)
    Discord::Notifier.message(message) unless Rails.env.test?
  end
end

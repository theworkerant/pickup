class Notifications
  def initialize(hook)
    @hook = hook
  end

  def player_reserved(match, player)
    if match.ringers.count > 0
      notify("<@#{player.uid}> wants to **#{match.name}** join but slots are full! They've been added as a possible ringer.")
    elsif match.slots_remaining == 0
      notify("
      <@#{player.uid}> just joined and **#{match.name}** is **now full**!! However! _You can still [queue as a ringer](#{match.reserve_url})_ and you'll be notified if a slot opens up.
      ")
    else
      notify("<@#{player.uid}> just joined **#{match.name}**, **#{match.slots_remaining}** slots left... [reserve now](#{match.reserve_url})!")
    end
  end

  def player_relinquished(match)
    if match.ringers.count > 0
      mentions = match.ringers.map do |ringer|
        "<@!#{ringer.uid}>"
      end.join(" ")

      notify("#{mentions} A slot is now available in **#{match.name}**! [click to reserve](#{match.reserve_url})")
    end
  end

  def announce_match(match)
    image = image_url("games/#{match.game.slug}.webp")
    embed = Discord::Embed.new do
      title("#{match.host.username} wants to play #{match.game.name}")
      description(match.description)
      add_field(name: "Match Name", value: "**#{match.name}**")
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

  def mention_match_for_interested(host, interested)
    mentions = (interested-[host]).map do |user|
      "<@!#{user.uid}>"
    end.join(" ")

    if interested.present?
      notify(":point_up: :point_up: :point_up: **Rally, soldiers!** #{mentions}")
    end
  end

  private
  def image_url(name)
    ENV["HOST_URL"] + ActionController::Base.helpers.asset_url(name)
  end

  def notify(message)
    Discord::Notifier.message(message, url: @hook.url) unless Rails.env.test?
  end
end

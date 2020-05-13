Discord::Notifier.setup do |config|
  config.url = ENV["DISCORD_WEBHOOK"]
  config.username = "Pickup Bot"

  # Defaults to `false`
  # config.wait = true
end

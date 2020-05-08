Rails.application.config.middleware.use OmniAuth::Builder do
  provider :discord, ENV['DISCORD_APP_ID'], ENV['DISCORD_APP_SECRET'], scope: 'identify email connections guilds'
end

class PickupDiscord
  include HTTParty
  API_URL = "https://discord.com/api".freeze

  def initialize(token)
    @headers = {headers: {Authorization: "Bearer #{token}"}}
  end

  def me()
    request("/users/@me")
  end

  def guilds
    request("/users/@me/guilds")
  end

  private
  def request(endpoint)
    response = self.class.get(API_URL + endpoint, @headers)
    JSON.parse(response.body)
  end
end

class Webhook < ApplicationRecord
  belongs_to :user
  before_save :encrypt
  after_save :decrypt
  after_initialize :decrypt

  def self.with_guilds(guilds)
    hooks = order(:order).where(guild_id: guilds.map{|g| g["id"]})
    guilds.map do |guild|
      guild["hooks"] = hooks.select{|h| h.guild_id === guild["id"]}
      OpenStruct.new(guild)
    end.select{|guild| guild["hooks"].count > 0 }
  end

  private
  def encrypt
    self.url = EncryptionService.encrypt(self.url)
  end
  def decrypt
    self.url = EncryptionService.decrypt(self.url)
  end
end

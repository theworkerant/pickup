class User < ApplicationRecord
  def self.find_or_create_from_auth_hash(auth)
		where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
			user.provider = auth.provider
			user.uid = auth.uid
			user.username = auth.info.name
			user.email = auth.info.email
			user.picture = auth.info.image
			user.credentials = EncryptionService.encrypt(auth.credentials.to_json)
			user.save!
		end
	end

  def discord_api
    @discord ||= PickupDiscord.new(creds.token)
  end
  def creds
    OpenStruct.new(JSON.parse(EncryptionService.decrypt(credentials)))
  end
end

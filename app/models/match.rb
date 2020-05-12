class Match < ApplicationRecord
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

  private

  def reserve_host
    self.reservations.create(user: host)
  end
end

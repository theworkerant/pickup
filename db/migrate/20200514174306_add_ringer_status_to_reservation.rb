class AddRingerStatusToReservation < ActiveRecord::Migration[6.0]
  def change
    add_column :reservations, :ringer, :boolean, default: false
  end
end

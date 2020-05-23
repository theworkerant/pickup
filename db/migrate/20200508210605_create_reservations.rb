class CreateReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :reservations do |t|

      t.belongs_to :match
      t.belongs_to :user

      t.timestamps
    end
  end
end

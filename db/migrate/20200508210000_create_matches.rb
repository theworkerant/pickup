class CreateMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|

      t.belongs_to :game
      t.belongs_to :user
      t.datetime :start_time
      t.integer :duration
      t.integer :slots

      t.timestamps
    end
  end
end

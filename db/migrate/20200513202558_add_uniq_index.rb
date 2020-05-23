class AddUniqIndex < ActiveRecord::Migration[6.0]
  def change
    add_index :games, :slug, unique: true
    add_index :reservations, [:match_id, :user_id], unique: true
  end
end

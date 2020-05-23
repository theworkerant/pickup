class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|

      t.string :name
      t.string :slug
      t.json :defaults

      t.timestamps
    end
  end
end

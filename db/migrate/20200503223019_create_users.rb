class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|

      t.string :provider
      t.string :uid
      t.string :email
      t.string :username
      t.string :picture

      t.timestamps
    end
  end
end

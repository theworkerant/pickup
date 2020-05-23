class GuildWebhooks < ActiveRecord::Migration[6.0]
  def change
    create_table :webhooks do |t|
      t.belongs_to :user
      t.integer :order
      t.string :name
      t.string :url
      t.string :guild_id

      t.timestamps
    end

    add_reference :matches, :webhook, index: true
  end
end

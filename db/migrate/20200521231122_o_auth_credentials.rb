class OAuthCredentials < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :credentials, :text
  end
end

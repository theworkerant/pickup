class AddMatchNameAndDay < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :name, :string
    add_index :matches, :name, unique: true
  end
end

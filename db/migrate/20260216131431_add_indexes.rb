class AddIndexes < ActiveRecord::Migration[7.1]
  def change
    add_index :feature_flags, :name, unique: true
  end
end

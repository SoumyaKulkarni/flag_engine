class AddIndexes < ActiveRecord::Migration[7.1]
  def change
    add_index :feature_flags, :name, unique: true
    add_index :overrides, [:feature_flag_id, :override_type, :override_id],
              name: "idx_override_lookup"
  end
end

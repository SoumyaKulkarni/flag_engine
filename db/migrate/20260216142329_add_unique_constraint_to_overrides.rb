class AddUniqueConstraintToOverrides < ActiveRecord::Migration[7.1]
  def change
    add_index :overrides,
              [:feature_flag_id, :override_type, :override_id],
              unique: true,
              name: "uniq_override_per_scope"
  end
end

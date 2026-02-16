class CreateOverrides < ActiveRecord::Migration[7.1]
  def change
    create_table :overrides do |t|
      t.references :feature_flag, null: false, foreign_key: true
      t.string :override_type
      t.integer :override_id
      t.boolean :enabled

      t.timestamps
    end
  end
end

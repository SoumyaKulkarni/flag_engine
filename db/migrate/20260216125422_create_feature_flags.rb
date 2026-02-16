class CreateFeatureFlags < ActiveRecord::Migration[7.1]
  def change
    create_table :feature_flags do |t|
      t.string :name
      t.boolean :enabled
      t.string :description

      t.timestamps
    end
  end
end

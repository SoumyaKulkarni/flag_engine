# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_02_16_142329) do
  create_table "feature_flags", force: :cascade do |t|
    t.string "name"
    t.boolean "enabled"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_feature_flags_on_name", unique: true
  end

  create_table "overrides", force: :cascade do |t|
    t.integer "feature_flag_id", null: false
    t.string "override_type"
    t.integer "override_id"
    t.boolean "enabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_flag_id", "override_type", "override_id"], name: "uniq_override_per_scope", unique: true
    t.index ["feature_flag_id"], name: "index_overrides_on_feature_flag_id"
  end

  add_foreign_key "overrides", "feature_flags"
end

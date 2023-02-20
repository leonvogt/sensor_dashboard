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

ActiveRecord::Schema[7.0].define(version: 2023_02_19_213057) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"


  create_table "devices", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "access_token"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_token"], name: "index_devices_on_access_token", unique: true
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "sensor_data", force: :cascade do |t|
    t.bigint "sensor_id", null: false
    t.decimal "value", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sensor_id"], name: "index_sensor_data_on_sensor_id"
  end

  create_table "sensors", force: :cascade do |t|
    t.string "sensor_type", null: false
    t.string "chart_type", null: false
    t.bigint "device_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_sensors_on_device_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "locale", default: "en"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "devices", "users"
  add_foreign_key "sensor_data", "sensors"
  add_foreign_key "sensors", "devices"
end

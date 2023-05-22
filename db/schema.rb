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

ActiveRecord::Schema[7.0].define(version: 2023_05_21_163422) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alarm_rules", force: :cascade do |t|
    t.bigint "sensor_id", null: false
    t.string "rule_type"
    t.decimal "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sensor_id"], name: "index_alarm_rules_on_sensor_id"
  end

  create_table "api_errors", force: :cascade do |t|
    t.text "error_message"
    t.bigint "device_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_api_errors_on_device_id"
  end

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

  create_table "mobile_app_connections", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "platform"
    t.string "notification_token"
    t.string "app_version"
    t.string "unique_mobile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["notification_token"], name: "index_mobile_app_connections_on_notification_token", unique: true
    t.index ["user_id"], name: "index_mobile_app_connections_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.string "type", null: false
    t.jsonb "params"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["read_at"], name: "index_notifications_on_read_at"
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient"
  end

  create_table "rule_violations", force: :cascade do |t|
    t.bigint "alarm_rule_id", null: false
    t.integer "status"
    t.string "violation_text"
    t.datetime "closed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alarm_rule_id"], name: "index_rule_violations_on_alarm_rule_id"
  end

  create_table "sensor_measurements", force: :cascade do |t|
    t.bigint "sensor_id", null: false
    t.decimal "value", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sensor_id"], name: "index_sensor_measurements_on_sensor_id"
  end

  create_table "sensors", force: :cascade do |t|
    t.string "sensor_type", null: false
    t.string "chart_type", null: false
    t.bigint "device_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "show_in_dashboard", default: true
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
    t.boolean "is_admin", default: false
    t.string "authentication_token"
    t.string "temporary_sign_in_token"
    t.datetime "temporary_sign_in_token_created_at"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "alarm_rules", "sensors"
  add_foreign_key "api_errors", "devices"
  add_foreign_key "devices", "users"
  add_foreign_key "mobile_app_connections", "users"
  add_foreign_key "rule_violations", "alarm_rules"
  add_foreign_key "sensor_measurements", "sensors"
  add_foreign_key "sensors", "devices"
end

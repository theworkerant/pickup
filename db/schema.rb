# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_22_143608) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.json "defaults"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["slug"], name: "index_games_on_slug", unique: true
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "user_id"
    t.text "description"
    t.datetime "start_time"
    t.integer "duration"
    t.integer "slots"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.bigint "webhook_id"
    t.index ["game_id"], name: "index_matches_on_game_id"
    t.index ["name"], name: "index_matches_on_name", unique: true
    t.index ["user_id"], name: "index_matches_on_user_id"
    t.index ["webhook_id"], name: "index_matches_on_webhook_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "match_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "ringer", default: false
    t.index ["match_id", "user_id"], name: "index_reservations_on_match_id_and_user_id", unique: true
    t.index ["match_id"], name: "index_reservations_on_match_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "email"
    t.string "username"
    t.string "picture"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "credentials"
  end

  create_table "webhooks", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "order"
    t.string "name"
    t.string "url"
    t.string "guild_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_webhooks_on_user_id"
  end

end

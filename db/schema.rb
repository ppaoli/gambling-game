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

ActiveRecord::Schema[7.0].define(version: 2023_03_20_204055) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "competitions", force: :cascade do |t|
    t.string "name"
    t.bigint "sport_id", null: false
    t.bigint "country_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_competitions_on_country_id"
    t.index ["sport_id"], name: "index_competitions_on_sport_id"
  end

  create_table "competitions_enrollments", force: :cascade do |t|
    t.bigint "competition_id", null: false
    t.bigint "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competition_id"], name: "index_competitions_enrollments_on_competition_id"
    t.index ["team_id"], name: "index_competitions_enrollments_on_team_id"
  end

  create_table "countries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.bigint "competition_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competition_id"], name: "index_games_on_competition_id"
  end

  create_table "games_enrollments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_games_enrollments_on_game_id"
    t.index ["user_id"], name: "index_games_enrollments_on_user_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_rounds_on_game_id"
  end

  create_table "sports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams_selections", force: :cascade do |t|
    t.bigint "games_enrollment_id", null: false
    t.bigint "round_id", null: false
    t.bigint "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["games_enrollment_id"], name: "index_teams_selections_on_games_enrollment_id"
    t.index ["round_id"], name: "index_teams_selections_on_round_id"
    t.index ["team_id"], name: "index_teams_selections_on_team_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "competitions", "countries"
  add_foreign_key "competitions", "sports"
  add_foreign_key "competitions_enrollments", "competitions"
  add_foreign_key "competitions_enrollments", "teams"
  add_foreign_key "games", "competitions"
  add_foreign_key "games_enrollments", "games"
  add_foreign_key "games_enrollments", "users"
  add_foreign_key "rounds", "games"
  add_foreign_key "teams_selections", "games_enrollments"
  add_foreign_key "teams_selections", "rounds"
  add_foreign_key "teams_selections", "teams"
end

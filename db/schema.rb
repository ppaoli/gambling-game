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

ActiveRecord::Schema[7.0].define(version: 2023_04_24_222626) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "competitions", force: :cascade do |t|
    t.string "name"
    t.bigint "sport_id", null: false
    t.bigint "country_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sport_monk_competition_id"
    t.integer "sport_monk_sport_id"
    t.integer "sport_monk_country_id"
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
    t.integer "sport_monk_country_id"
    t.string "name"
  end

  create_table "fixtures", force: :cascade do |t|
    t.datetime "starting_at", precision: nil
    t.bigint "competition_id", null: false
    t.integer "home_team_id"
    t.integer "away_team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "winner_id"
    t.bigint "round_id", null: false
    t.integer "sport_monk_fixture_id"
    t.boolean "finished"
    t.integer "sport_monk_round_id"
    t.index ["competition_id"], name: "index_fixtures_on_competition_id"
    t.index ["round_id"], name: "index_fixtures_on_round_id"
  end

  create_table "game_invitations", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_invitations_on_game_id"
    t.index ["user_id"], name: "index_game_invitations_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "competition_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "stake"
    t.date "start_date"
    t.datetime "deadline", precision: nil
    t.integer "num_players"
    t.string "title"
    t.boolean "is_public", default: true
    t.bigint "user_id", null: false
    t.integer "max_entries_per_user", default: 2
    t.integer "current_round_number"
    t.index ["competition_id"], name: "index_games_on_competition_id"
    t.index ["user_id"], name: "index_games_on_user_id"
  end

  create_table "games_enrollments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.integer "entry_id"
    t.index ["game_id"], name: "index_games_enrollments_on_game_id"
    t.index ["user_id"], name: "index_games_enrollments_on_user_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.bigint "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sport_monk_round_id"
    t.string "sport_monk_round_name"
    t.boolean "finished"
    t.datetime "starting_at"
    t.index ["game_id"], name: "index_rounds_on_game_id"
  end

  create_table "sports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "sport_monk_sport_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sport_monk_participant_id"
    t.string "image_path"
  end

  create_table "teams_selections", force: :cascade do |t|
    t.bigint "games_enrollment_id", null: false
    t.bigint "round_id", null: false
    t.bigint "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sport_monk_team_id"
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
    t.string "first_name"
    t.string "last_name"
    t.string "mobile_number"
    t.string "gender"
    t.string "address"
    t.string "country"
    t.string "city"
    t.string "postal_code"
    t.string "username"
    t.date "date_of_birth"
    t.string "street"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "competitions", "countries"
  add_foreign_key "competitions", "sports"
  add_foreign_key "competitions_enrollments", "competitions"
  add_foreign_key "competitions_enrollments", "teams"
  add_foreign_key "fixtures", "competitions"
  add_foreign_key "fixtures", "rounds"
  add_foreign_key "game_invitations", "games"
  add_foreign_key "game_invitations", "users"
  add_foreign_key "games", "competitions"
  add_foreign_key "games", "users"
  add_foreign_key "games_enrollments", "games"
  add_foreign_key "games_enrollments", "users"
  add_foreign_key "rounds", "games"
  add_foreign_key "teams_selections", "games_enrollments"
  add_foreign_key "teams_selections", "rounds"
  add_foreign_key "teams_selections", "teams"
end

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

ActiveRecord::Schema[8.0].define(version: 2025_09_01_103702) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "companies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "facebook"
    t.string "twitter"
    t.string "url"
    t.string "logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_companies_on_name", unique: true
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.integer "member_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "known_skills", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "skill_id", null: false
    t.index ["skill_id"], name: "index_known_skills_on_skill_id"
    t.index ["user_id", "skill_id"], name: "index_known_skills_on_user_id_and_skill_id"
    t.index ["user_id"], name: "index_known_skills_on_user_id"
  end

  create_table "needed_skills", force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "skill_id", null: false
    t.index ["skill_id"], name: "index_needed_skills_on_skill_id"
    t.index ["team_id", "skill_id"], name: "index_needed_skills_on_team_id_and_skill_id"
    t.index ["team_id"], name: "index_needed_skills_on_team_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_skills_on_code", unique: true
  end

  create_table "team_members", force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "user_id", null: false
    t.boolean "approved", null: false
    t.string "kind", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id", "user_id"], name: "index_team_members_on_team_id_and_user_id", unique: true
    t.index ["team_id"], name: "index_team_members_on_team_id"
    t.index ["user_id"], name: "index_team_members_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.boolean "approve_new_members", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_teams_on_created_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "telegram"
    t.text "tokens"
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "known_skills", "skills"
  add_foreign_key "known_skills", "users"
  add_foreign_key "needed_skills", "skills"
  add_foreign_key "needed_skills", "teams"
  add_foreign_key "team_members", "teams"
  add_foreign_key "team_members", "users"
end

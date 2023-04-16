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

ActiveRecord::Schema[7.0].define(version: 2023_04_16_153810) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "announcements", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "solution_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["solution_id"], name: "index_comments_on_solution_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "sign_ups", force: :cascade do |t|
    t.string "full_name"
    t.string "faculty_number"
    t.string "email"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "solutions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "task_id", null: false
    t.string "token", null: false
    t.binary "script"
    t.json "meta", default: "{}", null: false
    t.integer "points", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "completed_at"
    t.string "user_token"
    t.string "script_keys", array: true
    t.bigint "vimrc_revision_id"
    t.index ["task_id"], name: "index_solutions_on_task_id"
    t.index ["token"], name: "index_solutions_on_token", unique: true
    t.index ["user_id"], name: "index_solutions_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.text "description"
    t.text "input", null: false
    t.text "output", null: false
    t.datetime "opens_at", precision: nil
    t.datetime "closes_at", precision: nil
    t.integer "points", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "number", null: false
    t.string "filetype"
    t.string "file_extension"
    t.index ["closes_at"], name: "index_tasks_on_closes_at"
    t.index ["number"], name: "index_tasks_on_number", unique: true
  end

  create_table "user_tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "label", null: false
    t.string "body", null: false
    t.json "meta", default: "{}", null: false
    t.datetime "activated_at", precision: nil
    t.datetime "trashed_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_tokens_on_user_id"
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
    t.string "faculty_number", null: false
    t.string "full_name", null: false
    t.string "name", null: false
    t.boolean "admin", default: false, null: false
    t.boolean "comment_notification", default: true, null: false
    t.string "photo"
    t.string "github"
    t.string "discord"
    t.text "about"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "points_breakdown", default: "{}", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vimrc_revisions", force: :cascade do |t|
    t.bigint "vimrc_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vimrc_id"], name: "index_vimrc_revisions_on_vimrc_id"
  end

  create_table "vimrcs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_vimrcs_on_user_id"
  end

  create_table "vouchers", force: :cascade do |t|
    t.string "code", null: false
    t.bigint "user_id"
    t.datetime "claimed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_vouchers_on_user_id"
  end

end

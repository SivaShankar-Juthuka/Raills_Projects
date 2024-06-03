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

ActiveRecord::Schema[7.1].define(version: 2024_06_03_044022) do
  create_table "assignments", force: :cascade do |t|
    t.integer "task_id", null: false
    t.integer "assigned_to_id", null: false
    t.integer "assigned_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_by_id"], name: "index_assignments_on_assigned_by_id"
    t.index ["assigned_to_id"], name: "index_assignments_on_assigned_to_id"
    t.index ["task_id", "assigned_to_id"], name: "index_assignments_on_task_id_and_assigned_to_id", unique: true
    t.index ["task_id"], name: "index_assignments_on_task_id"
  end

  create_table "record_sessions", force: :cascade do |t|
    t.string "session_id"
    t.integer "user_id", null: false
    t.boolean "active_session"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "session_expiry"
    t.index ["user_id"], name: "index_record_sessions_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "task_name"
    t.string "status"
    t.date "due_date"
    t.integer "user_id", null: false
    t.string "priority_level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["priority_level"], name: "index_tasks_on_priority_level"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "user_tasks", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "task_id", null: false
    t.string "task_name"
    t.string "status"
    t.date "due_date"
    t.string "priority_level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_user_tasks_on_task_id"
    t.index ["user_id"], name: "index_user_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", null: false
  end

  add_foreign_key "assignments", "tasks"
  add_foreign_key "assignments", "users", column: "assigned_by_id"
  add_foreign_key "assignments", "users", column: "assigned_to_id"
  add_foreign_key "record_sessions", "users"
  add_foreign_key "tasks", "users"
  add_foreign_key "user_tasks", "tasks"
  add_foreign_key "user_tasks", "users"
end

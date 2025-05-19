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

ActiveRecord::Schema[7.2].define(version: 2025_05_19_065106) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id", "user_id"], name: "index_memberships_on_project_id_and_user_id", unique: true
    t.index ["project_id"], name: "index_memberships_on_project_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "message_id", null: false
    t.bigint "chat_id", null: false
    t.jsonb "payload", null: false
    t.boolean "from_telegram", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id", "message_id"], name: "index_messages_on_chat_id_and_message_id", unique: true
  end

  create_table "projects", force: :cascade do |t|
    t.string "url"
    t.string "key", null: false
    t.datetime "host_confirmed_at", precision: nil
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "telegram_group_id"
    t.string "name", null: false
    t.jsonb "chat_member"
    t.datetime "chat_member_updated_at", precision: nil
    t.string "custom_username"
    t.string "host"
    t.string "bot_status"
    t.boolean "bot_can_manage_topics"
    t.string "telegram_group_type"
    t.jsonb "telegram_chat"
    t.boolean "telegram_group_is_forum"
    t.string "last_error"
    t.datetime "last_error_at", precision: nil
    t.string "topic_title_template"
    t.string "welcome_message"
    t.string "bot_token"
    t.string "bot_username"
    t.string "telegram_group_name"
    t.boolean "thread_on_start", default: true, null: false
    t.jsonb "skip_threads_ids", default: [], null: false
    t.bigint "tariff_id", null: false
    t.string "bot_id", null: false
    t.datetime "skip_widget_at", precision: nil
    t.index ["key"], name: "index_projects_on_key", unique: true
    t.index ["owner_id"], name: "index_projects_on_owner_id"
    t.index ["tariff_id"], name: "index_projects_on_tariff_id"
    t.index ["telegram_group_id"], name: "index_projects_on_telegram_group_id", unique: true
  end

  create_table "tariffs", force: :cascade do |t|
    t.decimal "price", null: false
    t.string "title", null: false
    t.text "details", null: false
    t.integer "max_visitors_count", null: false
    t.integer "max_operators_count", null: false
    t.boolean "custom_bot_allowed", null: false
    t.boolean "transaction_mails_allowed", null: false
    t.boolean "marketing_mails_allowed", null: false
    t.integer "position", null: false
    t.datetime "archived_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "button_title", null: false
    t.boolean "is_default", default: false, null: false
    t.index ["position"], name: "index_tariffs_on_position", unique: true
    t.index ["title"], name: "index_tariffs_on_title", unique: true
  end

  create_table "telegram_events", force: :cascade do |t|
    t.jsonb "payload", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "telegram_users", id: :bigint, default: nil, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "photo_url"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.string "last_login_from_ip_address"
    t.bigint "telegram_user_id", null: false
    t.boolean "super_admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at"
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["telegram_user_id"], name: "index_users_on_telegram_user_id", unique: true
  end

  create_table "visitor_sessions", force: :cascade do |t|
    t.string "cookie_id", null: false
    t.bigint "project_id", null: false
    t.bigint "visitor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "last_visit_id"
    t.bigint "first_visit_id"
    t.index ["cookie_id", "project_id"], name: "index_visitor_sessions_on_cookie_id_and_project_id", unique: true
    t.index ["first_visit_id"], name: "index_visitor_sessions_on_first_visit_id"
    t.index ["last_visit_id"], name: "index_visitor_sessions_on_last_visit_id"
    t.index ["project_id"], name: "index_visitor_sessions_on_project_id"
    t.index ["visitor_id"], name: "index_visitor_sessions_on_visitor_id"
  end

  create_table "visitors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_id", null: false
    t.bigint "telegram_message_thread_id"
    t.datetime "telegram_cached_at", precision: nil
    t.jsonb "topic_data"
    t.datetime "last_visit_at", precision: nil
    t.bigint "telegram_user_id", null: false
    t.jsonb "user_data", default: {}, null: false
    t.datetime "operator_replied_at", precision: nil
    t.index ["project_id", "telegram_user_id"], name: "index_visitors_on_project_id_and_telegram_user_id", unique: true, where: "(telegram_user_id IS NOT NULL)"
    t.index ["project_id"], name: "index_visitors_on_project_id"
    t.index ["telegram_user_id"], name: "index_visitors_on_telegram_user_id"
  end

  create_table "visits", force: :cascade do |t|
    t.string "key", null: false
    t.inet "remote_ip", null: false
    t.jsonb "location", null: false
    t.jsonb "page_data", default: {}, null: false
    t.jsonb "chat"
    t.string "referrer"
    t.datetime "registered_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "visitor_session_id", null: false
    t.jsonb "user_data", default: {}, null: false
    t.jsonb "visit_data", default: {}, null: false
    t.index ["key"], name: "index_visits_on_key", unique: true
    t.index ["visitor_session_id"], name: "index_visits_on_visitor_session_id"
  end

  add_foreign_key "memberships", "projects"
  add_foreign_key "memberships", "users"
  add_foreign_key "projects", "tariffs"
  add_foreign_key "projects", "users", column: "owner_id"
  add_foreign_key "visitor_sessions", "projects"
  add_foreign_key "visitor_sessions", "visitors"
end

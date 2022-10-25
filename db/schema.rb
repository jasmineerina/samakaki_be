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

ActiveRecord::Schema[7.0].define(version: 2022_10_24_025309) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "biodata_users", force: :cascade do |t|
    t.datetime "dob"
    t.string "address"
    t.string "marriage_status"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_biodata_users_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.datetime "date"
    t.string "venue"
    t.time "time"
    t.bigint "user_id"
    t.bigint "family_tree_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["family_tree_id"], name: "index_events_on_family_tree_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "family_trees", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_family_trees_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.string "descriptions"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "relations", force: :cascade do |t|
    t.string "name"
    t.integer "relation_name"
    t.integer "position"
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_relations", force: :cascade do |t|
    t.integer "connected_user_id"
    t.integer "status"
    t.integer "family_tree_id"
    t.string "token"
    t.bigint "user_id", null: false
    t.bigint "relation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["relation_id"], name: "index_user_relations_on_relation_id"
    t.index ["user_id"], name: "index_user_relations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "user_relations", "relations"
  add_foreign_key "user_relations", "users"
end

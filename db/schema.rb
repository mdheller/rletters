# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150321205255) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_administrators", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_administrators", ["email"], name: "index_admin_administrators_on_email", unique: true, using: :btree
  add_index "admin_administrators", ["reset_password_token"], name: "index_admin_administrators_on_reset_password_token", unique: true, using: :btree

  create_table "admin_markdown_pages", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_settings", force: :cascade do |t|
    t.string   "key",        limit: 255
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_settings", ["key"], name: "key_udx", unique: true, using: :btree

  create_table "admin_uploaded_asset_files", force: :cascade do |t|
    t.integer "admin_uploaded_asset_id"
    t.string  "style",                   limit: 255
    t.binary  "file_contents"
  end

  create_table "admin_uploaded_assets", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "file_file_name",    limit: 255
    t.string   "file_content_type", limit: 255
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "file_fingerprint",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "datasets", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "disabled"
    t.boolean  "fetch",                  default: false
  end

  add_index "datasets", ["user_id"], name: "index_datasets_on_user_id", using: :btree

  create_table "datasets_analysis_task_results", force: :cascade do |t|
    t.integer "datasets_analysis_task_id"
    t.string  "style",                     limit: 255
    t.binary  "file_contents"
  end

  create_table "datasets_analysis_tasks", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.datetime "finished_at"
    t.integer  "dataset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "failed",                          default: false
    t.string   "job_type",            limit: 255
    t.string   "result_file_name",    limit: 255
    t.string   "result_content_type", limit: 255
    t.integer  "result_file_size"
    t.datetime "result_updated_at"
    t.text     "params"
    t.string   "resque_key",          limit: 255
  end

  add_index "datasets_analysis_tasks", ["dataset_id"], name: "index_datasets_analysis_tasks_on_dataset_id", using: :btree

  create_table "datasets_entries", force: :cascade do |t|
    t.string   "uid",        limit: 255
    t.integer  "dataset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "datasets_entries", ["dataset_id"], name: "index_datasets_entries_on_dataset_id", using: :btree

  create_table "documents_categories", force: :cascade do |t|
    t.integer  "parent_id"
    t.integer  "sort_order"
    t.string   "name",       limit: 255
    t.text     "journals"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents_category_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "documents_category_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "documents_category_anc_desc_udx", unique: true, using: :btree
  add_index "documents_category_hierarchies", ["descendant_id"], name: "documents_category_desc_idx", using: :btree

  create_table "documents_stop_lists", force: :cascade do |t|
    t.string   "language",   limit: 255
    t.text     "list"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",                           null: false
    t.string   "name",                   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "per_page",                           default: 10
    t.string   "language",               limit: 255, default: "en"
    t.string   "timezone",               limit: 255, default: "Eastern Time (US & Canada)"
    t.string   "encrypted_password",     limit: 255, default: "",                           null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "csl_style_id"
    t.boolean  "workflow_active",                    default: false
    t.string   "workflow_class",         limit: 255
    t.text     "workflow_datasets",                  default: [],                                        array: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_csl_styles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "style"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users_libraries", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "url",        limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_libraries", ["user_id"], name: "index_users_libraries_on_user_id", using: :btree

  add_foreign_key "datasets", "users", name: "datasets_user_id_fk", on_delete: :cascade
  add_foreign_key "datasets_analysis_tasks", "datasets", name: "datasets_analysis_tasks_dataset_id_fk"
  add_foreign_key "datasets_entries", "datasets", name: "datasets_entries_dataset_id_fk", on_delete: :cascade
  add_foreign_key "documents_categories", "documents_categories", column: "parent_id", name: "documents_categories_parent_id_fk"
  add_foreign_key "documents_category_hierarchies", "documents_categories", column: "ancestor_id", name: "documents_category_hierarchies_ancestor_id_fk"
  add_foreign_key "documents_category_hierarchies", "documents_categories", column: "descendant_id", name: "documents_category_hierarchies_descendant_id_fk"
  add_foreign_key "users_libraries", "users", name: "users_libraries_user_id_fk", on_delete: :cascade
end

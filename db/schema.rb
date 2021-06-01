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

ActiveRecord::Schema.define(version: 2021_06_01_135352) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_memberships", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_memberships_on_account_id"
    t.index ["user_id"], name: "index_account_memberships_on_user_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.string "domain"
    t.bigint "company_id"
    t.boolean "paying", default: false
    t.boolean "churned", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "mrr"
    t.index ["company_id"], name: "index_accounts_on_company_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name"
    t.string "record_gid"
    t.integer "blob_id"
    t.time "created_at"
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_gid", "blob_id"], name: "index_active_storage_attachments_on_record_gid_and_blob_id", unique: true
    t.index ["record_gid", "name"], name: "index_active_storage_attachments_on_record_gid_and_name"
    t.index ["record_gid"], name: "index_active_storage_attachments_on_record_gid"
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key"
    t.string "filename"
    t.string "content_type"
    t.text "metadata"
    t.integer "byte_size"
    t.string "checksum"
    t.time "created_at"
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "activity_logs", force: :cascade do |t|
    t.integer "event_type"
    t.bigint "event_id"
    t.bigint "company_id"
    t.integer "visibility"
    t.bigint "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_activity_logs_on_post_id"
  end

  create_table "boards", force: :cascade do |t|
    t.bigint "company_id"
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.boolean "private", default: false
    t.integer "default_sort_order"
    t.boolean "unlisted", default: false
    t.boolean "roadmap_enabled", default: true
    t.index ["company_id"], name: "index_boards_on_company_id"
    t.index ["slug", "company_id"], name: "index_boards_on_slug_and_company_id", unique: true
  end

  create_table "changelog_entries", force: :cascade do |t|
    t.text "title"
    t.integer "status"
    t.string "slug"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_changelog_entries_on_company_id"
  end

  create_table "comment_created_events", force: :cascade do |t|
    t.bigint "comment_id"
    t.bigint "user_id"
    t.bigint "company_id"
    t.bigint "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "post_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "private", default: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "subdomain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subdomain"], name: "index_companies_on_subdomain", unique: true
  end

  create_table "company_settings", force: :cascade do |t|
    t.bigint "company_id"
    t.datetime "expires_at"
    t.string "billing_plan"
    t.string "pricing_version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "paddle_subscription_id"
    t.string "stripe_customer_id"
    t.string "api_key"
    t.string "intercom_workspace_id"
    t.string "intercom_default_board_slug"
    t.string "intercom_access_token"
    t.jsonb "intercom_canvas_settings", default: {}
    t.index ["company_id"], name: "index_company_settings_on_company_id"
  end

  create_table "contents", force: :cascade do |t|
    t.text "body"
    t.bigint "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "parent_type"
    t.bigint "parent_id"
    t.index ["parent_type", "parent_id"], name: "index_contents_on_parent_type_and_parent_id"
    t.index ["post_id"], name: "index_contents_on_post_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "images", force: :cascade do |t|
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lightning_feature_opt_ins", force: :cascade do |t|
    t.integer "feature_id", null: false
    t.integer "entity_id", null: false
    t.string "entity_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id", "entity_type"], name: "index_lightning_feature_opt_ins_on_entity_id_and_entity_type"
    t.index ["feature_id", "entity_id", "entity_type"], name: "opt_in_index", unique: true
  end

  create_table "lightning_features", force: :cascade do |t|
    t.string "key", null: false
    t.text "description"
    t.integer "state", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_lightning_features_on_key", unique: true
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.boolean "primary", default: false
    t.boolean "owner", default: false
    t.index ["company_id"], name: "index_memberships_on_company_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "board_id"
    t.string "slug"
    t.datetime "last_activity_at"
    t.integer "added_by_id"
    t.index ["board_id"], name: "index_posts_on_board_id"
    t.index ["slug", "board_id"], name: "index_posts_on_slug_and_board_id", unique: true
    t.index ["title"], name: "index_posts_on_title"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "status_changed_events", force: :cascade do |t|
    t.integer "old_value"
    t.integer "new_value"
    t.integer "admin_id"
    t.bigint "company_id"
    t.bigint "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", default: "", null: false
    t.string "last_name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.integer "role", default: 0
    t.string "provider"
    t.string "uid"
    t.string "job_title"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.integer "invited_by_id"
    t.integer "invitations_count", default: 0
    t.string "username"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "added_by_id"
    t.index ["post_id"], name: "index_votes_on_post_id"
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "account_memberships", "accounts"
  add_foreign_key "account_memberships", "users"
  add_foreign_key "accounts", "companies"
  add_foreign_key "boards", "companies"
  add_foreign_key "changelog_entries", "companies"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "company_settings", "companies"
  add_foreign_key "contents", "posts"
  add_foreign_key "memberships", "companies"
  add_foreign_key "memberships", "users"
  add_foreign_key "posts", "boards"
  add_foreign_key "posts", "users"
  add_foreign_key "taggings", "tags"
  add_foreign_key "users", "companies"
  add_foreign_key "votes", "posts"
  add_foreign_key "votes", "users"
end

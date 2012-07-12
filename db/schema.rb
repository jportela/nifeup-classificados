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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120104003317) do

  create_table "ad_tags", :force => true do |t|
    t.string   "tag"
    t.integer  "ad_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ad_tags", ["ad_id"], :name => "index_ad_tags_on_ad_id"

  create_table "ads", :force => true do |t|
    t.string   "title"
    t.integer  "closed",                 :default => 0
    t.text     "description"
    t.integer  "user_id"
    t.integer  "section_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "thumbnail_file_name"
    t.string   "thumbnail_content_type"
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
    t.float    "average_rate"
    t.integer  "final_evaluation_id"
    t.float    "relevance_factor",       :default => 0.0
  end

  add_index "ads", ["section_id"], :name => "index_ads_on_section_id"
  add_index "ads", ["user_id"], :name => "index_ads_on_user_id"

  create_table "ads_users", :id => false, :force => true do |t|
    t.integer  "ad_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "block_logs", :force => true do |t|
    t.datetime "begin"
    t.datetime "end"
    t.text     "reason"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "ad_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["ad_id"], :name => "index_comments_on_ad_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "evaluations", :force => true do |t|
    t.integer  "value"
    t.integer  "user_id"
    t.integer  "ad_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "evaluations", ["ad_id"], :name => "index_evaluations_on_ad_id"
  add_index "evaluations", ["user_id"], :name => "index_evaluations_on_user_id"

  create_table "favorites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "ad_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["ad_id"], :name => "index_favorites_on_ad_id"
  add_index "favorites", ["user_id"], :name => "index_favorites_on_user_id"

  create_table "final_evaluations", :force => true do |t|
    t.integer  "value"
    t.text     "comment"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", :force => true do |t|
    t.text     "reason"
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reports", ["comment_id"], :name => "index_reports_on_comment_id"
  add_index "reports", ["user_id"], :name => "index_reports_on_user_id"

  create_table "resources", :force => true do |t|
    t.integer  "ad_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link_file_name"
    t.string   "link_content_type"
    t.integer  "link_file_size"
    t.datetime "link_updated_at"
    t.string   "description"
  end

  add_index "resources", ["ad_id"], :name => "index_resources_on_ad_id"

  create_table "sections", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.boolean  "admin"
    t.float    "rate"
    t.datetime "blocked_until"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

end

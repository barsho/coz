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

ActiveRecord::Schema.define(:version => 20121025020658) do

  create_table "conversations", :force => true do |t|
    t.string   "title"
    t.integer  "conversationable_id"
    t.string   "conversationable_type"
    t.integer  "relative_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "conversations", ["conversationable_id", "created_at"], :name => "index_conversations_on_conversationable_id_and_created_at"
  add_index "conversations", ["relative_id"], :name => "index_conversations_on_relative_id"

  create_table "posts", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.integer  "conversation_id"
    t.integer  "relative_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "posts", ["relative_id"], :name => "index_posts_on_relative_id"
  add_index "posts", ["user_id", "conversation_id", "created_at"], :name => "index_posts_on_user_id_and_conversation_id_and_created_at"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "projects", ["user_id", "created_at"], :name => "index_projects_on_user_id_and_created_at"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end

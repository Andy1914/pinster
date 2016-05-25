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

ActiveRecord::Schema.define(version: 20140819180220) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "icon"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: true do |t|
    t.integer  "user_id"
    t.integer  "type"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contact_id"
  end

  create_table "devices", force: true do |t|
    t.string   "platform"
    t.integer  "user_id"
    t.text     "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.string   "user_ids"
    t.string   "name"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pin_likes", force: true do |t|
    t.integer  "user_id"
    t.integer  "pin_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pins", force: true do |t|
    t.string   "title"
    t.float    "longitude"
    t.float    "latitude"
    t.string   "location"
    t.integer  "category_id"
    t.integer  "user_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message"
    t.text     "shared_picture"
  end

  create_table "shared_pins", force: true do |t|
    t.integer  "user_id"
    t.integer  "contact_id"
    t.integer  "pin_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                      default: "",   null: false
    t.string   "encrypted_password",         default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "mobile"
    t.string   "date_of_birth"
    t.text     "profile_picture"
    t.string   "facebook_id"
    t.string   "authentication_token"
    t.string   "provider"
    t.string   "uid"
    t.string   "mobile_code"
    t.boolean  "mobile_verification_status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "notification",               default: true
    t.boolean  "push_notification",          default: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end

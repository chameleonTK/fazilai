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

ActiveRecord::Schema.define(version: 20140125131435) do

  create_table "achievements", primary_key: "aid", force: true do |t|
    t.string   "name"
    t.text     "detail"
    t.text     "img"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logs", primary_key: "lid", force: true do |t|
    t.integer  "user_id"
    t.integer  "proj_id"
    t.datetime "starttime"
    t.datetime "lefttime"
  end

  create_table "ownachieves", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "achievement_id"
  end

  create_table "projs", primary_key: "pid", force: true do |t|
    t.string   "name"
    t.string   "path"
    t.text     "detail"
    t.integer  "server_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "servers", primary_key: "sid", force: true do |t|
    t.string   "name"
    t.string   "domain"
    t.integer  "port"
    t.string   "suser"
    t.string   "spass"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", primary_key: "uid", force: true do |t|
    t.string   "email"
    t.string   "pass"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

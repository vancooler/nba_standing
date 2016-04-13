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

ActiveRecord::Schema.define(version: 20160409181120) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "conferences", force: true do |t|
    t.string   "conf_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "divisions", force: true do |t|
    t.string   "div_name"
    t.integer  "conf_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seasons", force: true do |t|
    t.integer  "start_year"
    t.integer  "end_year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "standings", force: true do |t|
    t.integer  "team_id"
    t.integer  "season_id"
    t.integer  "lost"
    t.integer  "win"
    t.float    "pct"
    t.float    "gb"
    t.integer  "conf_win"
    t.integer  "conf_lost"
    t.integer  "div_win"
    t.integer  "div_lost"
    t.integer  "home_win"
    t.integer  "home_lost"
    t.integer  "road_win"
    t.integer  "road_lost"
    t.integer  "last_ten_win"
    t.integer  "last_ten_lost"
    t.boolean  "streak_as_win"
    t.integer  "streak_number"
    t.integer  "div_rank"
    t.integer  "conf_rank"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: true do |t|
    t.string   "team_name"
    t.integer  "div_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

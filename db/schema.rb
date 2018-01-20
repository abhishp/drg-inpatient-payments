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

ActiveRecord::Schema.define(version: 20180120123515) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cities", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.integer "state_id", null: false
    t.index ["state_id"], name: "index_cities_on_state_id"
  end

  create_table "hospital_referral_regions", force: :cascade do |t|
    t.string "description", limit: 100, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["description"], name: "unique_constraint_hospital_referral_regions_on_description", unique: true
  end

  create_table "states", force: :cascade do |t|
    t.string "abbreviation", limit: 2, null: false
    t.string "name", limit: 50, null: false
    t.index ["abbreviation"], name: "unique_constraint_states_on_abbreviation", unique: true
    t.index ["name"], name: "unique_constraint_states_on_name", unique: true
  end

  add_foreign_key "cities", "states", on_delete: :cascade
end

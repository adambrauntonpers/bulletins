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

ActiveRecord::Schema.define(:version => 20110106193737) do

  create_table "adminusers", :force => true do |t|
    t.string "username", :null => false
  end

  create_table "bulletins", :force => true do |t|
    t.string  "from",      :default => "", :null => false
    t.text    "message"
    t.date    "validfrom",                 :null => false
    t.date    "validto",                   :null => false
    t.string  "createdBy", :default => "", :null => false
    t.string  "freetext",  :default => ""
    t.integer "year7",     :default => 0
    t.integer "year8",     :default => 0
    t.integer "year9",     :default => 0
    t.integer "year10",    :default => 0
    t.integer "year11",    :default => 0
  end

end

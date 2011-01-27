# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110127052334) do

  create_table "capacity_profile_groups", :force => true do |t|
    t.integer  "network_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "capacity_profiles", :force => true do |t|
    t.integer  "capacity_profile_group_id"
    t.integer  "link_id"
    t.decimal  "dt"
    t.string   "profile"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "configurations", :force => true do |t|
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "controller_groups", :force => true do |t|
    t.string   "description"
    t.integer  "network_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "controllers", :force => true do |t|
    t.string   "type"
    t.string   "controller_type"
    t.decimal  "dt"
    t.binary   "parameters"
    t.integer  "controller_group_id"
    t.integer  "network_id"
    t.integer  "link_id"
    t.integer  "node_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "demand_profile_groups", :force => true do |t|
    t.integer  "network_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "demand_profiles", :force => true do |t|
    t.integer  "demand_profile_group_id"
    t.integer  "link_id"
    t.decimal  "dt"
    t.string   "profile"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_groups", :force => true do |t|
    t.integer  "network_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "type"
    t.string   "event_type"
    t.decimal  "time"
    t.binary   "parameters"
    t.integer  "event_group_id"
    t.integer  "network_id"
    t.integer  "link_id"
    t.integer  "node_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "input_links", :force => true do |t|
    t.integer  "link_id"
    t.integer  "network_id"
    t.integer  "node_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "intersections", :force => true do |t|
    t.string   "description"
    t.integer  "node_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", :force => true do |t|
    t.string   "type_link"
    t.string   "name"
    t.decimal  "length"
    t.decimal  "lanes"
    t.decimal  "capacity"
    t.decimal  "v"
    t.decimal  "w"
    t.decimal  "jam_den"
    t.decimal  "cap_drop"
    t.binary   "geo_cache"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "network_families", :force => true do |t|
    t.integer  "network_id"
    t.integer  "child_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "network_links", :force => true do |t|
    t.integer  "link_id"
    t.integer  "network_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "network_nodes", :force => true do |t|
    t.integer  "node_id"
    t.integer  "network_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "network_routes", :force => true do |t|
    t.integer  "route_id"
    t.integer  "network_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "networks", :force => true do |t|
    t.string   "description"
    t.decimal  "dt"
    t.boolean  "ml_control"
    t.boolean  "q_control"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nodes", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "type_node"
    t.decimal  "geo_x"
    t.decimal  "geo_y"
    t.decimal  "geo_z"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "output_links", :force => true do |t|
    t.integer  "link_id"
    t.integer  "network_id"
    t.integer  "node_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "route_links", :force => true do |t|
    t.integer  "route_id"
    t.integer  "link_id"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "routes", :force => true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scenarios", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "dt"
    t.decimal  "b_time"
    t.decimal  "e_time"
    t.string   "length_units"
    t.string   "v_types"
    t.integer  "network_id"
    t.integer  "demand_profile_group_id"
    t.integer  "capacity_profile_group_id"
    t.integer  "split_ratio_profile_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sensor_locations", :force => true do |t|
    t.integer  "link_id"
    t.integer  "network_id"
    t.integer  "sensor_id"
    t.decimal  "r_offset"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sensors", :force => true do |t|
    t.string   "type_sensor"
    t.string   "link_type"
    t.boolean  "measurement"
    t.boolean  "virtual"
    t.decimal  "geo_x"
    t.decimal  "geo_y"
    t.decimal  "geo_z"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "split_ratio_profile_groups", :force => true do |t|
    t.integer  "network_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "split_ratio_profiles", :force => true do |t|
    t.integer  "split_ratio_profile_group_id"
    t.integer  "node_id"
    t.decimal  "dt"
    t.string   "profile"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

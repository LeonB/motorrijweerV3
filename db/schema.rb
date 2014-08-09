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

ActiveRecord::Schema.define(version: 20140808194818) do

  create_table "forecasts", force: true do |t|
    t.datetime "from_datetime"
    t.datetime "to_datetime"
    t.string   "period"
    t.integer  "station_id"
    t.string   "provider"
    t.string   "description"
    t.string   "weather_type"
    t.string   "precipitation_type"
    t.decimal  "precipitation_accumulation_in_centimers_max", precision: 5, scale: 4
    t.decimal  "precipitation_accumulation_in_centimers_min", precision: 5, scale: 4
    t.decimal  "precipitation_accumulation_in_centimers_avg", precision: 5, scale: 4
    t.decimal  "precipitation_probability",                   precision: 5, scale: 2
    t.decimal  "precipitation_in_mm_per_hour_max",            precision: 5, scale: 4
    t.decimal  "precipitation_in_mm_per_hour_min",            precision: 5, scale: 4
    t.decimal  "precipitation_in_mm_per_hour_avg",            precision: 5, scale: 4
    t.decimal  "winter_precipitation_in_mm_per_hour_max",     precision: 5, scale: 4
    t.decimal  "winter_precipitation_in_mm_per_hour_min",     precision: 5, scale: 4
    t.decimal  "winter_precipitation_in_mm_per_hour_avg",     precision: 5, scale: 4
    t.decimal  "temperature_in_celcius_max",                  precision: 5, scale: 2
    t.decimal  "temperature_in_celcius_min",                  precision: 5, scale: 2
    t.decimal  "temperature_in_celcius_avg",                  precision: 5, scale: 2
    t.decimal  "apparent_temperature_in_celcius_max",         precision: 5, scale: 2
    t.decimal  "apparent_temperature_in_celcius_min",         precision: 5, scale: 2
    t.decimal  "apparent_temperature_in_celcius_avg",         precision: 5, scale: 2
    t.decimal  "wind_speed_in_meters_per_second_max",         precision: 5, scale: 2
    t.decimal  "wind_speed_in_meters_per_second_min",         precision: 5, scale: 2
    t.decimal  "wind_speed_in_meters_per_second_avg",         precision: 5, scale: 2
    t.integer  "wind_bearing_in_degrees_max"
    t.integer  "wind_bearing_in_degrees_min"
    t.integer  "wind_bearing_in_degrees_avg"
    t.decimal  "cloud_cover_max",                             precision: 5, scale: 2
    t.decimal  "cloud_cover_min",                             precision: 5, scale: 2
    t.decimal  "cloud_cover_avg",                             precision: 5, scale: 2
    t.decimal  "humidity_max",                                precision: 5, scale: 2
    t.decimal  "humidity_min",                                precision: 5, scale: 2
    t.decimal  "humidity_avg",                                precision: 5, scale: 2
    t.decimal  "pressure_in_millibars_max",                   precision: 5, scale: 2
    t.decimal  "pressure_in_millibars_min",                   precision: 5, scale: 2
    t.decimal  "pressure_in_millibars_avg",                   precision: 5, scale: 2
    t.decimal  "visibility_in_meters_max",                    precision: 5, scale: 2
    t.decimal  "visibility_in_meters_min",                    precision: 5, scale: 2
    t.decimal  "visibility_in_meters_avg",                    precision: 5, scale: 2
    t.decimal  "ozone_in_dobson_max",                         precision: 5, scale: 2
    t.decimal  "ozone_in_dobson_min",                         precision: 5, scale: 2
    t.decimal  "ozone_in_dobson_avg",                         precision: 5, scale: 2
    t.decimal  "dew_point_in_celcius_max",                    precision: 5, scale: 2
    t.decimal  "dew_point_in_celcius_min",                    precision: 5, scale: 2
    t.decimal  "dew_point_in_celcius_avg",                    precision: 5, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forecasts", ["from_datetime"], name: "index_forecasts_on_from_datetime"
  add_index "forecasts", ["provider"], name: "index_forecasts_on_provider"
  add_index "forecasts", ["station_id"], name: "index_forecasts_on_station_id"
  add_index "forecasts", ["to_datetime"], name: "index_forecasts_on_to_datetime"

  create_table "observations", force: true do |t|
    t.datetime "from_datetime"
    t.datetime "to_datetime"
    t.string   "period"
    t.integer  "station_id"
    t.string   "provider"
    t.string   "description"
    t.string   "precipitation_type"
    t.decimal  "precipitation_in_mm_per_hour",    precision: 5, scale: 4
    t.decimal  "precipitation_probability",       precision: 5, scale: 2
    t.decimal  "temperature_in_celcius",          precision: 5, scale: 2
    t.decimal  "apparent_temperature_in_celcius", precision: 5, scale: 2
    t.decimal  "humidity",                        precision: 5, scale: 2
    t.decimal  "wind_speed_in_meters_per_second", precision: 5, scale: 2
    t.integer  "wind_bearing_in_degrees"
    t.decimal  "visibility_in_meters",            precision: 5, scale: 2
    t.decimal  "cloud_cover",                     precision: 5, scale: 2
    t.decimal  "pressure_in_millibars",           precision: 5, scale: 2
    t.decimal  "ozone_in_dobson",                 precision: 5, scale: 2
    t.decimal  "dew_point_in_celcius",            precision: 5, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "observations", ["from_datetime"], name: "index_observations_on_from_datetime"
  add_index "observations", ["provider"], name: "index_observations_on_provider"
  add_index "observations", ["station_id"], name: "index_observations_on_station_id"
  add_index "observations", ["to_datetime"], name: "index_observations_on_to_datetime"

  create_table "regions", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "regions", ["parent_id"], name: "index_regions_on_parent_id"

  create_table "stations", force: true do |t|
    t.string   "name"
    t.integer  "region_id"
    t.decimal  "latitude",   precision: 10, scale: 6
    t.decimal  "longitude",  precision: 10, scale: 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stations", ["latitude", "longitude"], name: "index_stations_on_latitude_and_longitude"
  add_index "stations", ["region_id"], name: "index_stations_on_region_id"

end

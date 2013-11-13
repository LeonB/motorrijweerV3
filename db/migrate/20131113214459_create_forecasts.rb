class CreateForecasts < ActiveRecord::Migration
  def change
    create_table :forecasts do |t|
      t.datetime   :from_datetime
      t.datetime   :to_datetime
      t.integer    :station_id
      t.string     :description
      t.string     :weather_type
      t.string     :precipitation_type
      t.decimal    :precipitation_probability, :precision => 2
      t.decimal    :precipitation_in_mm_per_hour_max, :precision => 4
      t.decimal    :precipitation_in_mm_per_hour_min, :precision => 4
      t.decimal    :precipitation_in_mm_per_hour_avg, :precision => 4
      t.decimal    :temperature_in_celcius_max, :precision => 2
      t.decimal    :temperature_in_celcius_min, :precision => 2
      t.decimal    :temperature_in_celcius_avg, :precision => 2
      t.decimal    :apparent_temperature_in_celcius_max, :precision => 2
      t.decimal    :apparent_temperature_in_celcius_min, :precision => 2
      t.decimal    :apparent_temperature_in_celcius_avg, :precision => 2
      t.decimal    :wind_speed_in_meters_per_second_max, :precision => 2
      t.decimal    :wind_speed_in_meters_per_second_min, :precision => 2
      t.decimal    :wind_speed_in_meters_per_second_avg, :precision => 2
      t.integer    :wind_bearing_in_degrees_max
      t.integer    :wind_bearing_in_degrees_min
      t.integer    :wind_bearing_in_degrees_avg
      t.decimal    :cloud_cover_max, :precision => 2
      t.decimal    :cloud_cover_min, :precision => 2
      t.decimal    :cloud_cover_avg, :precision => 2
      t.decimal    :humidity_max, :precision => 2
      t.decimal    :humidity_min, :precision => 2
      t.decimal    :humidity_avg, :precision => 2
      t.decimal    :pressure_in_millibars_max, :precision => 2
      t.decimal    :pressure_in_millibars_min, :precision => 2
      t.decimal    :pressure_in_millibars_avg, :precision => 2
      t.decimal    :visibility_in_meters_max, :precision => 2
      t.decimal    :visibility_in_meters_min, :precision => 2
      t.decimal    :visibility_in_meters_avg, :precision => 2
      t.decimal    :ozone_in_dobson_max, :precision => 2
      t.decimal    :ozone_in_dobson_min, :precision => 2
      t.decimal    :ozone_in_dobson_avg, :precision => 2
      t.decimal    :dew_point_max, :precision => 2
      t.decimal    :dew_point_min, :precision => 2
      t.decimal    :dew_point_avg, :precision => 2
      t.timestamps
    end
  end
end

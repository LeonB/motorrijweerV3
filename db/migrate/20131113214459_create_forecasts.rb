class CreateForecasts < ActiveRecord::Migration
  def change
    create_table :forecasts do |t|
      t.datetime   :from_datetime
      t.datetime   :to_datetime
      t.string     :period
      t.belongs_to :station
      t.string     :provider
      t.string     :description
      t.string     :weather_type
      t.string     :precipitation_type
      t.decimal    :precipitation_accumulation_in_centimers_max, :precision => 5, :scale => 4
      t.decimal    :precipitation_accumulation_in_centimers_min, :precision => 5, :scale => 4
      t.decimal    :precipitation_accumulation_in_centimers_avg, :precision => 5, :scale => 4
      t.decimal    :precipitation_probability, :precision => 5, :scale => 2
      t.decimal    :precipitation_in_mm_per_hour_max, :precision => 5, :scale => 4
      t.decimal    :precipitation_in_mm_per_hour_min, :precision => 5, :scale => 4
      t.decimal    :precipitation_in_mm_per_hour_avg, :precision => 5, :scale => 4
      t.decimal    :winter_precipitation_in_mm_per_hour_max, :precision => 5, :scale => 4
      t.decimal    :winter_precipitation_in_mm_per_hour_min, :precision => 5, :scale => 4
      t.decimal    :winter_precipitation_in_mm_per_hour_avg, :precision => 5, :scale => 4
      t.decimal    :temperature_in_celcius_max, :precision => 5, :scale => 2
      t.decimal    :temperature_in_celcius_min, :precision => 5, :scale => 2
      t.decimal    :temperature_in_celcius_avg, :precision => 5, :scale => 2
      t.decimal    :apparent_temperature_in_celcius_max, :precision => 5, :scale => 2
      t.decimal    :apparent_temperature_in_celcius_min, :precision => 5, :scale => 2
      t.decimal    :apparent_temperature_in_celcius_avg, :precision => 5, :scale => 2
      t.decimal    :wind_speed_in_meters_per_second_max, :precision => 5, :scale => 2
      t.decimal    :wind_speed_in_meters_per_second_min, :precision => 5, :scale => 2
      t.decimal    :wind_speed_in_meters_per_second_avg, :precision => 5, :scale => 2
      t.integer    :wind_bearing_in_degrees_max
      t.integer    :wind_bearing_in_degrees_min
      t.integer    :wind_bearing_in_degrees_avg
      t.decimal    :cloud_cover_max, :precision => 5, :scale => 2
      t.decimal    :cloud_cover_min, :precision => 5, :scale => 2
      t.decimal    :cloud_cover_avg, :precision => 5, :scale => 2
      t.decimal    :humidity_max, :precision => 5, :scale => 2
      t.decimal    :humidity_min, :precision => 5, :scale => 2
      t.decimal    :humidity_avg, :precision => 5, :scale => 2
      t.decimal    :pressure_in_millibars_max, :precision => 5, :scale => 2
      t.decimal    :pressure_in_millibars_min, :precision => 5, :scale => 2
      t.decimal    :pressure_in_millibars_avg, :precision => 5, :scale => 2
      t.decimal    :visibility_in_meters_max, :precision => 5, :scale => 2
      t.decimal    :visibility_in_meters_min, :precision => 5, :scale => 2
      t.decimal    :visibility_in_meters_avg, :precision => 5, :scale => 2
      t.decimal    :ozone_in_dobson_max, :precision => 5, :scale => 2
      t.decimal    :ozone_in_dobson_min, :precision => 5, :scale => 2
      t.decimal    :ozone_in_dobson_avg, :precision => 5, :scale => 2
      t.decimal    :dew_point_in_celcius_max, :precision => 5, :scale => 2
      t.decimal    :dew_point_in_celcius_min, :precision => 5, :scale => 2
      t.decimal    :dew_point_in_celcius_avg, :precision => 5, :scale => 2
      # t.decimal    :precipAccumulation
      t.timestamps

      t.index       :from_datetime
      t.index       :to_datetime
      t.index       :station_id
      t.index       :provider
    end
  end
end

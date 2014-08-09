class CreateObservations < ActiveRecord::Migration
  def change
    create_table :observations do |t|
      t.datetime   :from_datetime
      t.datetime   :to_datetime
      t.string     :period
      t.belongs_to :station
      t.string     :provider

      t.string     :description
      t.string     :precipitation_type
      t.decimal    :precipitation_in_mm_per_hour, :precision => 5, :scale => 4
      t.decimal    :precipitation_probability, :precision => 5, :scale => 2
      t.decimal    :temperature_in_celcius, :precision => 5, :scale => 2
      t.decimal    :apparent_temperature_in_celcius, :precision => 5, :scale => 2
      t.decimal    :humidity, :precision => 5, :scale => 2
      t.decimal    :wind_speed_in_meters_per_second, :precision => 5, :scale => 2
      t.integer    :wind_bearing_in_degrees
      t.decimal    :visibility_in_meters, :precision => 5, :scale => 2
      t.decimal    :cloud_cover, :precision => 5, :scale => 2
      t.decimal    :pressure_in_millibars, :precision => 5, :scale => 2
      t.decimal    :ozone_in_dobson, :precision => 5, :scale => 2
      t.decimal    :dew_point_in_celcius, :precision => 5, :scale => 2

      t.timestamps

      t.index       :from_datetime
      t.index       :to_datetime
      t.index       :station_id
      t.index       :provider
    end
  end
end

require 'ruby-units'

module WeatherProviders
  class WeatherProvider
    PERIOD_MINUTE = 1.minute
    PERIOD_HOUR = 1.hour
    PERIOD_DAY = 1.day
    FIELDS = [
      :from_datetime,
      :to_datetime,
      :description,
      :weather_type,
      :precipitation_type,
      :precipitation_accumulation_in_centimers_max,
      :precipitation_accumulation_in_centimers_min,
      :precipitation_accumulation_in_centimers_avg,
      :precipitation_probability,
      :precipitation_in_mm_per_hour_max,
      :precipitation_in_mm_per_hour_min,
      :precipitation_in_mm_per_hour_avg,
      :winter_precipitation_in_mm_per_hour_max,
      :winter_precipitation_in_mm_per_hour_min,
      :winter_precipitation_in_mm_per_hour_avg,
      :temperature_in_celcius_max,
      :temperature_in_celcius_min,
      :temperature_in_celcius_avg,
      :apparent_temperature_in_celcius_max,
      :apparent_temperature_in_celcius_min,
      :apparent_temperature_in_celcius_avg,
      :wind_speed_in_meters_per_second_max,
      :wind_speed_in_meters_per_second_min,
      :wind_speed_in_meters_per_second_avg,
      :wind_bearing_in_degrees_max,
      :wind_bearing_in_degrees_min,
      :wind_bearing_in_degrees_avg,
      :cloud_cover_max,
      :cloud_cover_min,
      :cloud_cover_avg,
      :humidity_max,
      :humidity_min,
      :humidity_avg,
      :pressure_in_millibars_max,
      :pressure_in_millibars_min,
      :pressure_in_millibars_avg,
      :visibility_in_meters_max,
      :visibility_in_meters_min,
      :visibility_in_meters_avg,
      :ozone_in_dobson_max,
      :ozone_in_dobson_min,
      :ozone_in_dobson_avg,
      :dew_point_in_celcius_max,
      :dew_point_in_celcius_min,
      :dew_point_in_celcius_avg
    ]

    attr_accessor :results

    def initialize
      self.results = {
        :created   => 0,
        :failed    => 0,
        :processed => 0,
        :skipped   => 0,
        :updated   => 0
      }
    end

    def import_forecasts(station)
      self.send(:initialize)
      api_data = self.get_api_data(station)
      yield(api_data)
      puts "Processed #{self.results[:processed]} forecasts"
      puts "Created #{self.results[:created]} forecasts"
      puts "Updated #{self.results[:updated]} forecasts"
      puts "Skipped #{self.results[:skipped]} forecasts"
      puts "#{self.results[:failed]} forecasts failed saving"
      return self.results
    end

    def get_api_data(station)
      yield
    end
    cache_method :get_api_data, 60.minutes.to_i

    def collect_data(*args)
      data = {}

      Forecast.column_names.each do |column_name|
        method_name = "get_#{column_name}"
        if self.respond_to? method_name
          value = self.send(method_name, *args)
          data[column_name.to_sym] = value
          # self.instance_eval(method_name) = value
        end
      end

      return data
    end

    def get_station_id(station, data, period)
      return station.id
    end

    def get_provider(station, data, period)
      return self.class::PROVIDER
    end

    # Match the forecast's data with the database
    # If it exists: merge the data??
    # If not: just save it
    def save(data)
      self.results[:processed] += 1

      f = Forecast.where(
        :station_id => data[:station_id],
        :from_datetime => data[:from_datetime],
        :to_datetime => data[:to_datetime],
        :provider => data[:provider]
      ).first_or_initialize

      attributes = data.each do |attr, value|
          next if attr == Forecast.primary_key
          next if f.send(:all_timestamp_attributes).include?(attr.to_sym)
          Forecast.column_names.include?(attr.to_s)
      end

      f.attributes = attributes
      new_record = f.new_record?
      changed = f.changed?

      if not changed
        self.results[:skipped] += 1
        return f
      # else
        # changes = f.changes
        # changes.each do |i, data|
          # data[0] = data[0].to_s
          # data[1] = data[1].to_s
        # end
        # puts changes
      end

      if not f.save
        puts "Could not save forecast. Errors: #{f.errors.messages}"
        self.results[:failed] += 1
        return f
      end

      if new_record
        self.results[:created] += 1
      elsif changed
        self.results[:updated] += 1
      end

      return f
    end

  end
end

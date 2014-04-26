require 'ruby-units'

module WeatherProviders
  class WeatherProvider
    PERIOD_MINUTE = 1.minute
    PERIOD_HOUR = 1.hour
    PERIOD_DAY = 1.day
    FIELDS = [
      :from_datetime,
      :to_datetime,
      :period,
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

    # Collect api data, split it in periods and save per period
    def import_forecasts(station)
      self.send(:initialize)
      api_data = self.get_api_data(station)

      # Check for minutely data
      self.collect_processed_minutely_data(station, api_data).each do |d|
        self.save(d)
      end if self.supported_periods.include? PERIOD_MINUTE

      # Check for hourly data
      self.collect_processed_hourly_data(station, api_data).each do |d|
        self.save(d)
      end if self.supported_periods.include? PERIOD_HOUR

      # Check for daily data
      self.collect_processed_daily_data(station, api_data).each do |d|
        self.save(d)
      end if self.supported_periods.include? PERIOD_DAY

      Rails.logger.debug "Processed #{self.results[:processed]} forecasts"
      Rails.logger.debug "Created #{self.results[:created]} forecasts"
      Rails.logger.debug "Updated #{self.results[:updated]} forecasts"
      Rails.logger.debug "Skipped #{self.results[:skipped]} forecasts"
      Rails.logger.debug "#{self.results[:failed]} forecasts failed saving"
      return self.results
    end

    # Delegates the collecting of api_data to child classes
    def get_api_data(station)
      yield
    end
    cache_method :get_api_data, 60.minutes.to_i

    # Convert api_data to AR data based on the available methods in that
    # weatherprovider class
    def convert_data(*args)
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

    def get_period(station, data, period)
      if period == self.class::PERIOD_MINUTE
        return 'minute'
      elsif period == self.class::PERIOD_HOUR
        return 'hour'
      elsif period == self.class::PERIOD_DAY
        return 'day'
      end
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

      # Create a forecast from the data
      f = self.forecast_from_data(data)

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
        # Rails.logger.debug changes
      end

      if not f.save
        Rails.logger.debug "Could not save forecast. Errors: #{f.errors.messages}"
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

    def forecast_from_data(data)
      # Find forecast or create a new one
      f = Forecast.where(
        :station_id => data[:station_id],
        :from_datetime => data[:from_datetime],
        :to_datetime => data[:to_datetime],
        :provider => data[:provider]
      ).first_or_initialize

      # Collect all attributes that match a field in the forecast model
      attributes = data.each do |attr, value|
          next if attr == Forecast.primary_key
          next if f.send(:all_timestamp_attributes).include?(attr.to_sym)
          Forecast.column_names.include?(attr.to_s)
      end

      # Add collected attributes to forecast
      f.attributes = attributes

      # Check some attributes which can also be calculated
      # So if they are empty: calculate them and append them to the object
      if data['apparent_temperature_in_celcius_max'].nil?
        f.apparent_temperature_in_celcius_max = f.calculate_apparent_temperature_in_celcius_max
      end
      if data['apparent_temperature_in_celcius_min'].nil?
        f.apparent_temperature_in_celcius_min = f.calculate_apparent_temperature_in_celcius_min
      end
      if data['apparent_temperature_in_celcius_avg'].nil?
        f.apparent_temperature_in_celcius_avg = f.calculate_apparent_temperature_in_celcius_avg
      end

      return f
    end

  end
end

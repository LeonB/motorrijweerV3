# work around bug in YrNo library
require 'multi_xml'

module WeatherProviders::YrNo
  class Forecasts < WeatherProviders::Forecasts
    PROVIDER = 'yr.no'

    def supported_periods
      [
        PERIOD_HOUR,
        PERIOD_DAY
      ]
    end

    def get_api_data(station)
      ::YrNo::locationforecast(station.latitude, station.longitude)
    end
    # cache_method :get_api_data, 60.minutes.to_i

    def collect_processed_hourly_data(station, data)
      return [] if not data.has_key?(:weatherdata)

      Rails.logger.debug "#{PROVIDER}: Fetching hourly data for #{station.name}"

      # Collect all data points and order them by hour
      from_times = data.weatherdata.product.time.map { |p| p.from.to_datetime }.uniq.sort
      points = ActiveSupport::OrderedHash.new
      from_times.each do |t|
        points[t] = data.weatherdata.product.time.select do |p|
          p.from.to_datetime >= t and
            p.to.to_datetime <= (t + 1.hours)
        end
      end

      # Clear all dates with no data
      points = points.select { |k, v| v.size > 0 }

      hourly_data = []

      Rails.logger.debug "#{PROVIDER}: Parsing hourly data for #{station.name} (#{points.size})"
      points.each do |t, hourly|
        d = self.convert_data(station, hourly, PERIOD_HOUR)
        hourly_data << d
      end
      return hourly_data
    end

    def collect_processed_daily_data(station, data)
      return [] if not data.has_key?(:daily)
      Rails.logger.debug "#{PROVIDER}: Fetching daily data for #{station.name}"
      daily_data = []

      Rails.logger.debug "#{PROVIDER}: Parsing daily data for #{station.name} (#{points.size})"
      data.daily.data.each do |daily|
        d = self.convert_data(station, daily, PERIOD_DAY)
        daily_data << d
      end
      return daily_data
    end

    def get_from_datetime(station, data, period)
      return data.first.from.to_datetime
    end

    def get_to_datetime(station, data, period)
      return (data.first.to.to_datetime + 1.hour)
    end

    def get_description(station, data, period)
      return nil
    end

    def get_weather_type(station, data, period)
      return nil
    end

    def get_precipitation_type(station, data, period)
      return nil
    end

    def get_precipitation_accumulation_in_centimers_max(station, data, period)
      return nil
    end

    def get_precipitation_accumulation_in_centimers_min(station, data, period)
      return nil
    end

    def get_precipitation_accumulation_in_centimers_avg(station, data, period)
      return nil
    end

    def get_precipitation_probability(station, data, period)
      return nil
    end

    def get_precipitation_in_mm_per_hour_max(station, data, period)
      # Find the highest value and return it
      return data.map { |p|
        next if not p.location
        next if not p.location.precipitation
        (
          p.location.precipitation.maxvalue.to_f or
          p.location.precipitation.value.to_f
        )
      }.compact.max
    end

    def get_precipitation_in_mm_per_hour_min(station, data, period)
      return data.map { |p|
        next if not p.location
        next if not p.location.precipitation
        (
          p.location.precipitation.minvalue.to_f or
          p.location.precipitation.value.to_f
        )
      }.compact.min
    end

    def get_precipitation_in_mm_per_hour_avg(station, data, period)
      values = data.map { |p|
        next if not p.location
        next if not p.location.precipitation
        (
          p.location.precipitation.value.to_f
        )
      }.compact
      return 0.0 if values.size == 0
      return values.sum/values.size
    end

    def get_winter_precipitation_in_mm_per_hour_max(station, data, period)
      return nil
    end

    def get_winter_precipitation_in_mm_per_hour_min(station, data, period)
      return nil
    end

    def get_winter_precipitation_in_mm_per_hour_avg(station, data, period)
      return nil
    end

    def get_temperature_in_celcius_max(station, data, period)
      return data.map { |p|
        next if not p.location
        next if not p.location.temperature
        p.location.temperature.value.to_f
      }.compact.max
    end

    def get_temperature_in_celcius_min(station, data, period)
      return data.map { |p|
        next if not p.location
        next if not p.location.temperature
        p.location.temperature.value.to_f
      }.compact.min
    end

    def get_temperature_in_celcius_avg(station, data, period)
      values = data.map { |p|
        next if not p.location
        next if not p.location.temperature
        (
          p.location.temperature.value.to_f
        )
      }.compact
      return nil if values.size == 0
      return values.sum/values.size
    end

    def get_apparent_temperature_in_celcius_max(station, data, period)
      return nil
    end

    def get_apparent_temperature_in_celcius_min(station, data, period)
      return nil
    end

    def get_apparent_temperature_in_celcius_avg(station, data, period)
      return nil
    end

    def get_wind_speed_in_meters_per_second_max(station, data, period)
      return data.map { |p|
        next if not p.location
        next if not p.location.windSpeed
        p.location.windSpeed.mps.to_f
      }.compact.max
    end

    def get_wind_speed_in_meters_per_second_min(station, data, period)
      return data.map { |p|
        next if not p.location
        next if not p.location.windSpeed
        p.location.windSpeed.mps.to_f
      }.compact.min
    end

    def get_wind_speed_in_meters_per_second_avg(station, data, period)
      values = data.map { |p|
        next if not p.location
        next if not p.location.windSpeed
        (
          p.location.windSpeed.mps.to_f
        )
      }.compact
      return nil if values.size == 0
      return values.sum/values.size
    end

    def get_wind_bearing_in_degrees_max(station, data, period)
      return data.map { |p|
        next if not p.location
        next if not p.location.windDirection
        p.location.windDirection.deg.to_f
      }.compact.max
    end

    def get_wind_bearing_in_degrees_min(station, data, period)
      return data.map { |p|
        next if not p.location
        next if not p.location.windDirection
        p.location.windDirection.deg.to_f
      }.compact.min
    end

    def get_wind_bearing_in_degrees_avg(station, data, period)
      values = data.map { |p|
        next if not p.location
        next if not p.location.windDirection
        (
          p.location.windDirection.deg.to_f
        )
      }.compact
      return nil if values.size == 0
      return values.sum/values.size
    end

    def get_cloud_cover_max(station, data, period)
      return data.map { |p|
        next if not p.location
        next if not p.location.cloudiness
        p.location.cloudiness.percent.to_f
      }.compact.max
    end

    def get_cloud_cover_min(station, data, period)
      return data.map { |p|
        next if not p.location
        next if not p.location.cloudiness
        p.location.cloudiness.percent.to_f
      }.compact.min
    end

    def get_cloud_cover_avg(station, data, period)
      values = data.map { |p|
        next if not p.location
        next if not p.location.cloudiness
        (
          p.location.cloudiness.percent.to_f
        )
      }.compact
      return nil if values.size == 0
      return values.sum/values.size
    end

    def get_humidity_max(station, data, period)
      return data.map { |p|
        next if not p.location
        next if not p.location.humidity
        p.location.humidity.percent.to_f
      }.compact.max
    end

    def get_humidity_min(station, data, period)
      return data.map { |p|
        next if not p.location
        next if not p.location.humidity
        p.location.humidity.percent.to_f
      }.compact.min
    end

    def get_humidity_avg(station, data, period)
      values = data.map { |p|
        next if not p.location
        next if not p.location.humidity
        (
          p.location.humidity.percent.to_f
        )
      }.compact
      return nil if values.size == 0
      return values.sum/values.size
    end

    def get_pressure_in_millibars_max(station, data, period)
      mslp = data.map { |p|
        next if not p.location
        next if not p.location.pressure
        p.location.pressure.value.to_f
      }.compact.max

      u = Unit.new("#{mslp} Hectopascals")
      return u.to('millibars').scalar.to_f
    end

    def get_pressure_in_millibars_min(station, data, period)
      mslp = data.map { |p|
        next if not p.location
        next if not p.location.pressure
        p.location.pressure.value.to_f
      }.compact.min

      u = Unit.new("#{mslp} Hectopascals")
      return u.to('millibars').scalar.to_f
    end

    def get_pressure_in_millibars_avg(station, data, period)
      values = data.map { |p|
        next if not p.location
        next if not p.location.pressure
        (
          p.location.pressure.value.to_f
        )
      }.compact

      return nil if values.size == 0
      mslp = values.sum/values.size

      u = Unit.new("#{mslp} Hectopascals")
      return u.to('millibars').scalar.to_f
    end

    def get_visibility_in_meters_max(station, data, period)
      return nil
    end

    def get_visibility_in_meters_min(station, data, period)
      return nil
    end

    def get_visibility_in_meters_avg(station, data, period)
      return nil
    end

    def get_ozone_in_dobson_max(station, data, period)
      return nil
    end

    def get_ozone_in_dobson_min(station, data, period)
      return nil
    end

    def get_ozone_in_dobson_avg(station, data, period)
      return nil
    end

    def get_dew_point_in_celcius_max(station, data, period)
      return data.map { |p|
        next if not p.location
        next if not p.location.dewpointTemperature
        p.location.dewpointTemperature.value.to_f
      }.compact.max
    end

    def get_dew_point_in_celcius_min(station, data, period)
      return data.map { |p|
        next if not p.location
        next if not p.location.dewpointTemperature
        p.location.dewpointTemperature.value.to_f
      }.compact.min
    end

    def get_dew_point_in_celcius_avg(station, data, period)
      values = data.map { |p|
        next if not p.location
        next if not p.location.dewpointTemperature
        (
          p.location.dewpointTemperature.value.to_f
        )
      }.compact
      return nil if values.size == 0
      return values.sum/values.size
    end

  end # class
end # module

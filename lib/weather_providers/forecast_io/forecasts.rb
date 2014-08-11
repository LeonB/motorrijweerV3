module WeatherProviders::ForecastIo
  class Forecasts < WeatherProviders::Forecasts
    PROVIDER = 'forecast.io'

    def supported_periods
      [
        PERIOD_HOUR,
        PERIOD_DAY
      ]
    end

    def get_api_data(station)
      # https://api.forecast.io/forecast/9ccd69acf062e01564240edd8a71f3d2/51.423981,5.392537
      return ForecastIO.forecast(station.latitude, station.longitude)
    end
    cache_method :get_api_data, 60.minutes.to_i

    # def collect_processed_minutely_data(station, data)
      # return [] if not data.has_key?(:minutely)
      # Rails.logger.debug "#{ForecastIo::PROVIDER}: Fetching minutely data for #{station.name}"
      # minutely_data = []
      # data.minutely.data.each do |minutely|
        # d = self.convert_data(station, minutely, WeatherProvider::PERIOD_MINUTE)
        # minutely_data << d
      # end
      # return minutely_data
    # end

    def collect_processed_hourly_data(station, data)
      return [] if not data or not data.has_key?(:hourly)
      Rails.logger.debug "#{PROVIDER}: Fetching hourly data for #{station.name}"
      hourly_data = []

      Rails.logger.debug "#{PROVIDER}: Parsing hourly data for #{station.name} (#{data.hourly.data.size})"
      data.hourly.data.each do |hourly|
        d = self.convert_data(station, hourly, PERIOD_HOUR)
        hourly_data << d
      end
      return hourly_data
    end

    def collect_processed_daily_data(station, data)
      return [] if not data or not data.has_key?(:daily)
      Rails.logger.debug "#{PROVIDER}: Fetching daily data for #{station.name}"
      daily_data = []

      Rails.logger.debug "#{PROVIDER}: Parsing daily data for #{station.name} (#{data.daily.data.size})"
      data.daily.data.each do |daily|
        d = self.convert_data(station, daily, PERIOD_DAY)
        daily_data << d
      end
      return daily_data
    end

    def get_from_datetime(station, data, period)
      return Time.at(data.time).to_datetime
    end

    def get_to_datetime(station, data, period)
      from_datetime = self.get_from_datetime(station, data, period)
      return from_datetime + period
    end

    def get_description(station, data, period)
      return data.summary
    end

    def get_weather_type(station, data, period)
      return data.summary
    end

    def get_precipitation_type(station, data, period)
      return data.precipType
    end

    def get_precipitation_accumulation_in_centimers_max(station, data, period)
      return nil
    end

    def get_precipitation_accumulation_in_centimers_min(station, data, period)
      return nil
    end

    def get_precipitation_accumulation_in_centimers_avg(station, data, period)
      # depends on units=si
      return data.precipAccumulation.to_f
    end

    def get_precipitation_probability(station, data, period)
      return data.precipProbability.to_f
    end

    def get_precipitation_in_mm_per_hour_max(station, data, period)
      # depends on units=si
      return data.precipIntensityMax.to_f
    end

    def get_precipitation_in_mm_per_hour_min(station, data, period)
      # depends on units=si
      return data.precipIntensityMin.to_f
    end

    def get_precipitation_in_mm_per_hour_avg(station, data, period)
      # depends on units=si
      return data.precipIntensity.to_f
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
      return data.temperatureMax.to_f
    end

    def get_temperature_in_celcius_min(station, data, period)
      return data.temperatureMin.to_f
    end

    def get_temperature_in_celcius_avg(station, data, period)
      # depends on units=si
      return data.temperature.to_f
    end

    def get_apparent_temperature_in_celcius_max(station, data, period)
      # depends on units=si
      return data.apparentTemperatureMax.to_f
    end

    def get_apparent_temperature_in_celcius_min(station, data, period)
      # depends on units=si
      return data.apparentTemperatureMin.to_f
    end

    def get_apparent_temperature_in_celcius_avg(station, data, period)
      # depends on units=si
      return data.apparentTemperature.to_f
    end

    def get_wind_speed_in_meters_per_second_max(station, data, period)
      return nil
    end

    def get_wind_speed_in_meters_per_second_min(station, data, period)
      return nil
    end

    def get_wind_speed_in_meters_per_second_avg(station, data, period)
      # depends on units=si
      return data.windSpeed.to_f
    end

    def get_wind_bearing_in_degrees_max(station, data, period)
      return nil
    end

    def get_wind_bearing_in_degrees_min(station, data, period)
      return nil
    end

    def get_wind_bearing_in_degrees_avg(station, data, period)
      return data.windBearing.to_f
    end

    def get_cloud_cover_max(station, data, period)
      return nil
    end

    def get_cloud_cover_min(station, data, period)
      return nil
    end

    def get_cloud_cover_avg(station, data, period)
      return data.cloudCover.to_f
    end

    def get_humidity_max(station, data, period)
      return nil
    end

    def get_humidity_min(station, data, period)
      return nil
    end

    def get_humidity_avg(station, data, period)
      return data.humidity.to_f
    end

    def get_pressure_in_millibars_max(station, data, period)
      return nil
    end

    def get_pressure_in_millibars_min(station, data, period)
      return nil
    end

    def get_pressure_in_millibars_avg(station, data, period)
      # depends on units=si
      u = Unit.new("#{data.pressure} Hectopascals")
      return u.to('millibars').scalar.to_f
    end

    def get_visibility_in_meters_max(station, data, period)
      return nil
    end

    def get_visibility_in_meters_min(station, data, period)
      return nil
    end

    def get_visibility_in_meters_avg(station, data, period)
      u = Unit.new("#{data.visibility} kilometers")
      return u.to('meters').scalar.to_f
    end

    def get_ozone_in_dobson_max(station, data, period)
      return nil
    end

    def get_ozone_in_dobson_min(station, data, period)
      return nil
    end

    def get_ozone_in_dobson_avg(station, data, period)
      return data.ozone.to_f
    end

    def get_dew_point_in_celcius_max(station, data, period)
      return nil
    end

    def get_dew_point_in_celcius_min(station, data, period)
      return nil
    end

    def get_dew_point_in_celcius_avg(station, data, period)
      # depends on units=si
      return data.dewPoint.to_f
    end

  end
end

module WeatherProviders::ForecastIo
  class Observations < WeatherProviders::Observations
    PROVIDER = 'forecast.io'

    def supported_periods
      [
        PERIOD_HOUR,
        PERIOD_DAY
      ]
    end

    def get_api_data(station, date)
      # https://api.forecast.io/forecast/9ccd69acf062e01564240edd8a71f3d2/51.423981,5.392537
      ts = date.to_datetime.to_i
      return ForecastIO.forecast(station.latitude, station.longitude, {time: ts})
    end
    cache_method :get_api_data, 60.minutes.to_i

    def collect_processed_hourly_data(station, data)
      return [] if not data.has_key?(:hourly)
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
      return [] if not data.has_key?(:daily)
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

    def get_precipitation_in_mm_per_hour(station, data, period)
      # depends on units=si
      return data.precipIntensity.to_f
    end

    def get_precipitation_probability(station, data, period)
      return data.precipProbability.to_f
    end

    def get_temperature_in_celcius(station, data, period)
      return data.temperature.to_f
    end

    def get_apparent_temperature_in_celcius(station, data, period)
      # depends on units=si
      return data.apparentTemperature.to_f
    end

    def get_humidity(station, data, period)
      return data.humidity.to_f
    end

    def get_wind_speed_in_meters_per_second(station, data, period)
      # depends on units=si
      return data.windSpeed.to_f
    end

    def get_wind_bearing_in_degrees(station, data, period)
      return data.windBearing.to_f
    end

    def get_visibility_in_meters(station, data, period)
      u = Unit.new("#{data.visibility} kilometers")
      return u.to('meters').scalar.to_f
    end

    def get_cloud_cover(station, data, period)
      return data.cloudCover.to_f
    end

    def get_pressure_in_millibars(station, data, period)
      # depends on units=si
      u = Unit.new("#{data.pressure} Hectopascals")
      return u.to('millibars').scalar.to_f
    end

    def get_ozone_in_dobson(station, data, period)
      return data.ozone.to_f
    end

    def get_dew_point_in_celcius(station, data, period)
      # depends on units=si
      return data.dewPoint.to_f
    end
  end
end

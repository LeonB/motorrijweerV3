module WeatherProviders
  class ForecastIo < WeatherProviders::WeatherProvider
    PROVIDER = 'forecast.io'

    def import_forecasts(station)
      super do |api_data|
        if api_data.has_key?(:minutely)
          puts "#{ForecastIo::PROVIDER}: Fetching minutely data for #{station.name}"
          api_data.minutely.data.each do |minutely|
            d = self.collect_data(station, minutely, WeatherProvider::PERIOD_MINUTE)
            self.save(d)
          end
        end

        if api_data.has_key?(:hourly)
          puts "#{ForecastIo::PROVIDER}: Fetching hourly data for #{station.name}"
          api_data.hourly.data.each do |hourly|
            d = self.collect_data(station, hourly, WeatherProvider::PERIOD_HOUR)
            self.save(d)
          end
        end

        if api_data.has_key?(:daily)
          puts "#{ForecastIo::PROVIDER}: Fetching daily data for #{station.name}"
          api_data.daily.data.each do |daily|
            d = self.collect_data(station, daily, WeatherProvider::PERIOD_DAY)
            self.save(d)
          end
        end
      end
    end

    def get_api_data(station)
      # https://api.forecast.io/forecast/9ccd69acf062e01564240edd8a71f3d2/51.423981,5.392537
      return ForecastIO.forecast(station.latitude, station.longitude)
    end
    cache_method :get_api_data, 60.minutes.to_i

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

    def get_precipitation_accumulation_in_centimers(station, data, period)
      # depends on units=si
      return data.precipAccumulation
    end

    def get_precipitation_probability(station, data, period)
      return data.precipProbability
    end

    def get_precipitation_in_mm_per_hour_max(station, data, period)
      # depends on units=si
      return data.precipIntensityMax
    end

    def get_precipitation_in_mm_per_hour_min(station, data, period)
      # depends on units=si
      return data.precipIntensityMin
    end

    def get_precipitation_in_mm_per_hour_avg(station, data, period)
      # depends on units=si
      return data.precipIntensity
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
      return data.temperatureMax
    end

    def get_temperature_in_celcius_min(station, data, period)
      return data.temperatureMin
    end

    def get_temperature_in_celcius_avg(station, data, period)
      # depends on units=si
      return data.temperature
    end

    def get_apparent_temperature_in_celcius_max(station, data, period)
      # depends on units=si
      return data.apparentTemperatureMax
    end

    def get_apparent_temperature_in_celcius_min(station, data, period)
      # depends on units=si
      return data.apparentTemperatureMin
    end

    def get_apparent_temperature_in_celcius_avg(station, data, period)
      # depends on units=si
      return data.apparentTemperature
    end

    def get_wind_speed_in_meters_per_second_max(station, data, period)
      return nil
    end

    def get_wind_speed_in_meters_per_second_min(station, data, period)
      return nil
    end

    def get_wind_speed_in_meters_per_second_avg(station, data, period)
      # depends on units=si
      return data.windSpeed
    end

    def get_wind_bearing_in_degrees_max(station, data, period)
      return nil
    end

    def get_wind_bearing_in_degrees_min(station, data, period)
      return nil
    end

    def get_wind_bearing_in_degrees_avg(station, data, period)
      return data.windBearing
    end

    def get_cloud_cover_max(station, data, period)
      return nil
    end

    def get_cloud_cover_min(station, data, period)
      return nil
    end

    def get_cloud_cover_avg(station, data, period)
      return data.cloudCover
    end

    def get_humidity_max(station, data, period)
      return nil
    end

    def get_humidity_min(station, data, period)
      return nil
    end

    def get_humidity_avg(station, data, period)
      return data.humidity
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
      return data.ozone
    end

    def get_dew_point_in_celcius_max(station, data, period)
      return nil
    end

    def get_dew_point_in_celcius_min(station, data, period)
      return nil
    end

    def get_dew_point_in_celcius_avg(station, data, period)
      # depends on units=si
      return data.dewPoint
    end

  end
end

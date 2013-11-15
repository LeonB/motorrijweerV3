require 'pp'

module WeatherProviders
  class ForecastIo < WeatherProviders::WeatherProvider
    PROVIDER = 'forecast.io'
    PERIOD_MINUTE = 1.minute
    PERIOD_HOUR = 1.hour
    PERIOD_DAY = 1.day

    def forecasts(station)
      forecasts = []
      data = self.get_api_data(station)

      if data.has_key?(:minutely)
        data.minutely.data.each do |minutely|
          puts minutely.to_json
        end
      end

      if data.has_key?(:hourly)
        data.hourly.data.each do |hourly|
          data = self.collect_data(hourly, ForecastIo::PERIOD_HOUR)
          self.save(data)
          # f.attributes = data
          # pp hourly
          # pp f.pressure_in_millibars_avg.to_f
        end
      end

      if data.has_key?(:daily)
        data.daily.data.each do |daily|
          puts daily.to_json
          exit(2)
        end
      end

      # puts station.to_yaml
      # puts forecast.to_yaml
      puts "aaaaaallll done"
      exit(2)
      return forecasts
    end

    def get_api_data(station)
      # https://api.forecast.io/forecast/9ccd69acf062e01564240edd8a71f3d2/51.423981,5.392537
      return ForecastIO.forecast(station.latitude, station.longitude)
    end
    cache_method :get_api_data, 5.minutes.to_i

    def get_from_datetime(data, period)
      return Time.at(data.time).to_datetime
    end

    def get_to_datetime(data, period)
      from_datetime = self.get_from_datetime(data, period)
      return from_datetime + period
    end

    def get_description(data, period)
      return data.summary
    end

    def get_weather_type(data, period)
      return data.summary
    end

    def get_precipitation_type(data, period)
      return data.precipType
    end

    def get_precipitation_accumulation_in_centimers(data, period)
      # depends on units=si
      return data.precipAccumulation
    end

    def get_precipitation_probability(data, period)
      return data.precipProbability
    end

    def get_precipitation_in_mm_per_hour_max(data, period)
      # depends on units=si
      return data.precipIntensityMax
    end

    def get_precipitation_in_mm_per_hour_min(data, period)
      # depends on units=si
      return data.precipIntensityMin
    end

    def get_precipitation_in_mm_per_hour_avg(data, period)
      # depends on units=si
      return data.precipIntensity
    end

    def get_temperature_in_celcius_max(data, period)
      return data.temperatureMax
    end

    def get_temperature_in_celcius_min(data, period)
      return data.temperatureMin
    end

    def get_temperature_in_celcius_avg(data, period)
      # depends on units=si
      return data.temperature
    end

    def get_apparent_temperature_in_celcius_max(data, period)
      # depends on units=si
      return data.apparentTemperatureMax
    end

    def get_apparent_temperature_in_celcius_min(data, period)
      # depends on units=si
      return data.apparentTemperatureMin
    end

    def get_apparent_temperature_in_celcius_avg(data, period)
      # depends on units=si
      return data.apparentTemperature
    end

    def get_wind_speed_in_meters_per_second_max(data, period)
      return nil
    end

    def get_wind_speed_in_meters_per_second_min(data, period)
      return nil
    end

    def get_wind_speed_in_meters_per_second_avg(data, period)
      # depends on units=si
      return data.windSpeed
    end

    def get_wind_bearing_in_degrees_max(data, period)
      return nil
    end

    def get_wind_bearing_in_degrees_min(data, period)
      return nil
    end

    def get_wind_bearing_in_degrees_avg(data, period)
      return data.windBearing
    end

    def get_cloud_cover_max(data, period)
      return nil
    end

    def get_cloud_cover_min(data, period)
      return nil
    end

    def get_cloud_cover_avg(data, period)
      return data.cloudCover
    end

    def get_humidity_max(data, period)
      return nil
    end

    def get_humidity_min(data, period)
      return nil
    end

    def get_humidity_avg(data, period)
      return data.humidity
    end

    def get_pressure_in_millibars_max(data, period)
      return nil
    end

    def get_pressure_in_millibars_min(data, period)
      return nil
    end

    def get_pressure_in_millibars_avg(data, period)
      # depends on units=si
      u = Unit.new("#{data.pressure} Hectopascals")
      return u.to('millibars').scalar.to_f
    end

    def get_visibility_in_meters_max(data, period)
      return nil
    end

    def get_visibility_in_meters_min(data, period)
      return nil
    end

    def get_visibility_in_meters_avg(data, period)
      u = Unit.new("#{data.visibility} kilometers")
      return u.to('meters').scalar.to_f
    end

    def get_ozone_in_dobson_max(data, period)
      return nil
    end

    def get_ozone_in_dobson_min(data, period)
      return nil
    end

    def get_ozone_in_dobson_avg(data, period)
      return data.ozone
    end

    def get_dew_point_in_celcius_max(data, period)
      return nil
    end

    def get_dew_point_in_celcius_min(data, period)
      return nil
    end

    def get_dew_point_in_celcius_avg(data, period)
      # depends on units=si
      return data.dewPoint
    end

  end
end

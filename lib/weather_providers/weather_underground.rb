module WeatherProviders
  class WeatherUnderground < WeatherProviders::WeatherProvider
    PROVIDER = 'Weather Underground'

    def import_forecasts(station)
      super do |api_data|
        if api_data.has_key?('hourly_forecast')
          puts "#{WeatherUnderground::PROVIDER}: Fetching hourly data for #{station.name}"
          api_data['hourly_forecast'].each do |hourly|
            # puts hourly
            d = self.collect_data(station, hourly, WeatherProvider::PERIOD_HOUR)
            self.save(d)
          end
        end
      end
    end

    def get_api_data(station)
      # http://www.wunderground.com/weather/api/d/docs?d=resources/phrase-glossary
      super do
        w_api = Wunderground.new(language: 'NL')
        data = w_api.hourly10day_for("#{station.latitude},#{station.longitude}")
        return data
      end
    end

    def get_from_datetime(station, data, period)
      timestamp = data['FCTTIME']['epoch'].to_i
      return Time.at(timestamp).to_datetime
    end

    def get_to_datetime(station, data, period)
      from_datetime = self.get_from_datetime(station, data, period)
      return from_datetime + period
    end

    def get_description(station, data, period)
      return data['condition']
    end

    def get_weather_type(station, data, period)
      return data['condition']
    end

    def get_precipitation_type(station, data, period)
      return nil
    end

    def get_precipitation_accumulation_in_centimers(station, data, period)
      # depends on units=si
      return nil
    end

    def get_precipitation_probability(station, data, period)
      return data['pop']['metric'].to_f
    end

    def get_precipitation_in_mm_per_hour_max(station, data, period)
      return nil
    end

    def get_precipitation_in_mm_per_hour_min(station, data, period)
      return nil
    end

    def get_precipitation_in_mm_per_hour_avg(station, data, period)
      return data['qpf']['metric'].to_f
    end

    def get_winter_precipitation_in_mm_per_hour_max(station, data, period)
      return nil
    end

    def get_winter_precipitation_in_mm_per_hour_min(station, data, period)
      return nil
    end

    def get_winter_precipitation_in_mm_per_hour_avg(station, data, period)
      return data['snow']['metric'].to_f
    end

    def get_temperature_in_celcius_max(station, data, period)
      return nil
    end

    def get_temperature_in_celcius_min(station, data, period)
      return nil
    end

    def get_temperature_in_celcius_avg(station, data, period)
      return data['temp']['metric'].to_f
    end

    def get_apparent_temperature_in_celcius_max(station, data, period)
      return nil
    end

    def get_apparent_temperature_in_celcius_min(station, data, period)
      return nil
    end

    def get_apparent_temperature_in_celcius_avg(station, data, period)
      return data['feelslike']['metric'].to_f
    end

    def get_wind_speed_in_meters_per_second_max(station, data, period)
      return nil
    end

    def get_wind_speed_in_meters_per_second_min(station, data, period)
      return nil
    end

    def get_wind_speed_in_meters_per_second_avg(station, data, period)
      wspd = data['wspd']['metric']
      u = Unit.new("#{wspd} km/h")
      return u.to('m/s').scalar.to_f
    end

    def get_wind_bearing_in_degrees_max(station, data, period)
      return nil
    end

    def get_wind_bearing_in_degrees_min(station, data, period)
      return nil
    end

    def get_wind_bearing_in_degrees_avg(station, data, period)
      return data['wdir']['metric'].to_f
    end

    def get_cloud_cover_max(station, data, period)
      return nil
    end

    def get_cloud_cover_min(station, data, period)
      return nil
    end

    def get_cloud_cover_avg(station, data, period)
      return data['sky'].to_f
    end

    def get_humidity_max(station, data, period)
      return nil
    end

    def get_humidity_min(station, data, period)
      return nil
    end

    def get_humidity_avg(station, data, period)
      return data['humidity'].to_f
    end

    def get_pressure_in_millibars_max(station, data, period)
      return nil
    end

    def get_pressure_in_millibars_min(station, data, period)
      return nil
    end

    def get_pressure_in_millibars_avg(station, data, period)
      mslp =  data['mslp']['metric'].to_f
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
      return nil
    end

    def get_dew_point_in_celcius_min(station, data, period)
      return nil
    end

    def get_dew_point_in_celcius_avg(station, data, period)
      return data['dewpoint']['metric'].to_f
    end

  end
end

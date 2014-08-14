module WeatherProviders::WeatherUnderground
  class Observations < WeatherProviders::Observations
    PROVIDER = 'Weather Underground'

    def supported_periods
      [
        PERIOD_MINUTE,
        PERIOD_DAY
      ]
    end

    def get_api_data(station, date)
      # http://www.wunderground.com/weather/api/d/docs?d=resources/phrase-glossary
      w_api = Wunderground.new(language: 'NL')
      data = w_api.history_for(date, "#{station.latitude},#{station.longitude}")
      return data
    end
    cache_method :get_api_data, 60.minutes.to_i

    def collect_processed_minutely_data(station, api_data)
      return [] if not api_data.has_key?('history')
      return [] if not api_data['history'].has_key?('observations')
      Rails.logger.debug "#{PROVIDER}: Fetching minutely data for #{station.name}"
      minutely_data = []

      Rails.logger.debug "#{PROVIDER}: Parsing minutely data for #{station.name} (#{api_data['history']['observations'].size})"
      api_data['history']['observations'].each do |minutely|
        d = self.convert_data(station, minutely, PERIOD_MINUTE)
        minutely_data << d
      end
      return minutely_data
    end

    def collect_processed_daily_data(station, api_data)
      return [] if not api_data.has_key?('history')
      return [] if not api_data['history'].has_key?('dailysummary')
      Rails.logger.debug "#{PROVIDER}: Fetching daily data for #{station.name}"
      daily_data = []

      Rails.logger.debug "#{PROVIDER}: Parsing daily data for #{station.name} (#{api_data['history']['dailysummary'].size})"
      api_data['history']['dailysummary'].each do |daily|
        d = self.convert_data(station, daily, PERIOD_DAY)
        daily_data << d
      end
      return daily_data
    end

    def get_from_datetime(station, data, period)
      date = data['date']
      return Time.utc(date['year'], date['mon'], date['mday'],
                             date['hour'], date['min'])
      # Time.zone = date['tzname']
      # return Time.zone.local(date['year'], date['mon'], date['mday'],
      #                        date['hour'], date['min'])
    end

    def get_to_datetime(station, data, period)
      from_datetime = self.get_from_datetime(station, data, period)
      return from_datetime + period
    end

    def get_description(station, data, period)
      return data['conds']
    end

    def get_weather_type(station, data, period)
      return data['conds']
    end

    def get_precipitation_type(station, data, period)
      return nil
    end

    def get_precipitation_in_mm_per_hour(station, data, period)
      return nil if data['precipm'] == -999
      return nil if data['precipm'] == -9999
      return data['precipm']
    end

    def get_precipitation_probability(station, data, period)
    end

    def get_temperature_in_celcius(station, data, period)
      return data['tempm']
    end

    def get_apparent_temperature_in_celcius(station, data, period)
    end

    def get_humidity(station, data, period)
      return data['hum']
    end

    def get_wind_speed_in_meters_per_second(station, data, period)
      return data['wspdm']
    end

    def get_wind_bearing_in_degrees(station, data, period)
      return data['wdird']
    end

    def get_visibility_in_meters(station, data, period)
      return data['vism']
    end

    def get_cloud_cover(station, data, period)
    end

    def get_pressure_in_millibars(station, data, period)
      return data['pressurem']
    end

    def get_ozone_in_dobson(station, data, period)
    end

    def get_dew_point_in_celcius(station, data, period)
      return data['dewptm']
    end

  end
end

module WeatherProviders::KNMI
  class Observations < WeatherProviders::Observations
    PROVIDER = 'KNMI'

    def supported_periods
      [
        PERIOD_HOUR,
        # PERIOD_DAY
      ]
    end

    def get_api_data(station, date)
      # http://www.knmi.nl/klimatologie/uurgegevens/getdata_uur.cgi?stns=260&start=2014080901&end=2014081002&vars=DD:FH:FF:FX"
      knmi_station = station.knmi_station
      return {} if not knmi_station

      starts = date.to_time
      ends = date.to_time + 23.hour

      parameters = KNMI.parameters(period = "hourly", params = nil, categories = [
        'ATMS',
        'PRCP',
        'RDTN',
        'TEMP',
        'VISB',
        'WIND',
        'WTHR',
      ])
      request = KNMI.get_data(knmi_station, parameters, starts, ends)
      return KNMI.convert(parameters, request)
    end
    cache_method :get_api_data, 60.minutes.to_i

    def collect_processed_hourly_data(station, data)
      Rails.logger.debug "#{PROVIDER}: Fetching hourly data for #{station.name}"
      hourly_data = []

      Rails.logger.debug "#{PROVIDER}: Parsing hourly data for #{station.name} (#{data.size})"
      data.each do |hourly|
        d = self.convert_data(station, hourly, PERIOD_HOUR)
        hourly_data << d
      end
      return hourly_data
    end

    def collect_processed_daily_data(station, data)
      Rails.logger.debug "#{PROVIDER}: Fetching daily data for #{station.name}"
      daily_data = []

      Rails.logger.debug "#{PROVIDER}: Parsing daily data for #{station.name} (#{data.size})"
      data.each do |daily|
        d = self.convert_data(station, daily, PERIOD_DAY)
        daily_data << d
      end
      return daily_data
    end

    # YYYYMMDD = date (YYYY=year,MM=month,DD=day);
    # HH       = time (HH uur/hour, UT. 12 UT=13 MET, 14 MEZT. Hourly division 05 runs from 04.00 UT to 5.00 UT;
    # DD       = Mean wind direction (in degrees) during the 10-minute period preceding the time of observation (360=north, 90=east, 180=south, 270=west, 0=calm 990=variable);
    # FH       = Hourly mean wind speed (in 0.1 m/s);
    # FF       = Mean wind speed (in 0.1 m/s) during the 10-minute period preceding the time of observation;
    # FX       = Maximum wind gust (in 0.1 m/s) during the hourly division;
    # T        = Temperature (in 0.1 degrees Celsius) at 1.50 m at the time of observation;
    # T10N     = Minimum temperature (in 0.1 degrees Celsius) at 0.1 m in the preceding 6-hour period;
    # TD       = Dew point temperature (in 0.1 degrees Celsius) at 1.50 m at the time of observation;
    # SQ       = Sunshine duration (in 0.1 hour) during the hourly division, calculated from global radiation (-1 for <0.05 hour);
    # Q        = Global radiation (in J/cm2) during the hourly division;
    # DR       = Precipitation duration (in 0.1 hour) during the hourly division;
    # RH       = Hourly precipitation amount (in 0.1 mm) (-1 for <0.05 mm);
    # P        = Air pressure (in 0.1 hPa) reduced to mean sea level, at the time of observation;
    # VV       = Horizontal visibility at the time of observation (0=less than 100m, 1=100-200m, 2=200-300m,..., 49=4900-5000m, 50=5-6km, 56=6-7km, 57=7-8km, ..., 79=29-30km, 80=30-35km, 81=35-40km,..., 89=more than 70km);
    # N        = Cloud cover (in octants), at the time of observation (9=sky invisible);
    # U        = Relative atmospheric humidity (in percents) at 1.50 m at the time of observation;
    # M        = Fog 0=no occurrence, 1=occurred during the preceding hour and/or at the time of observation;
    # R        = Rainfall 0=no occurrence, 1=occurred during the preceding hour and/or at the time of observation;
    # S        = Snow 0=no occurrence, 1=occurred during the preceding hour and/or at the time of observation;
    # O        = Thunder  0=no occurrence, 1=occurred during the preceding hour and/or at the time of observation;
    # Y        = Ice formation 0=no occurrence, 1=occurred during the preceding hour and/or at the time of observation;
    # WW       = Present weather code (00-99), description for the hourly division. See http://www.knmi.nl/klimatologie/achtergrondinformatie/ww_lijst_engels.pdf;

    def get_from_datetime(station, data, period)
      # Remove 2 hours because of wrong time conversion in knmi library
      dt =data[:YYYYMMDD]

      # Work around silly KNMI hours counting
      dt = dt + (data[:HH] - 1).hour

      # Convert to UTC
      dt = dt - 2.hour

      return dt
    end

    def get_to_datetime(station, data, period)
      from_datetime = self.get_from_datetime(station, data, period)
      return from_datetime + period
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

    def get_precipitation_in_mm_per_hour(station, data, period)
      # RH = Hourly precipitation amount (in 0.1 mm) (-1 for <0.05 mm);
      return 0.05 if data[:RH] < 0
      return data[:RH]
    end

    def get_precipitation_probability(station, data, period)
      # DR = Precipitation duration (in 0.1 hour) during the hourly division;
      return data[:DR] * 0.1 if data[:DR]
      return nil
    end

    def get_temperature_in_celcius(station, data, period)
      # T = Temperature (in 0.1 degrees Celsius) at 1.50 m at the time of
      # observation;
      return data[:T]
    end

    def get_apparent_temperature_in_celcius(station, data, period)
      return nil
    end

    def get_humidity(station, data, period)
      # U = Relative atmospheric humidity (in percents) at 1.50 m at the time of
      # observation;
      return (data[:U]/100).to_f
    end

    def get_wind_speed_in_meters_per_second(station, data, period)
      # FH = Hourly mean wind speed (in 0.1 m/s);
      return data[:FH]
    end

    def get_wind_bearing_in_degrees(station, data, period)
      # DD = Mean wind direction (in degrees) during the 10-minute period
      # preceding the time of observation (360=north, 90=east, 180=south,
      # 270=west, 0=calm 990=variable);
      return data[:DD]
    end

    def get_visibility_in_meters(station, data, period)
      # VV = Horizontal visibility at the time of observation (0=less than 100m,
      # 1=100-200m, 2=200-300m,..., 49=4900-5000m, 50=5-6km, 56=6-7km, 57=7-8km,
      # ..., 79=29-30km, 80=30-35km, 81=35-40km,..., 89=more than 70km);
      case data[:VV]
      when 0
        return 0
      when 1..49
        return data[:VV] * 100
      when 50..55
        return 5000
      when 56..79
        return (data[:VV] - 50) * 1000
      when 80..88
        return (data[:VV] - 50) * 1000
      else
        return 70 * 1000
      end
    end

    def get_cloud_cover(station, data, period)
      # cloud coverage is in octants :s
      # http://en.difain.com/meteorology/cloudy.html
      return (data[:N]/9).to_f
    end

    def get_pressure_in_millibars(station, data, period)
      # P = Air pressure (in 0.1 hPa) reduced to mean sea level, at the time of
      # observation;
      u = Unit.new("#{data[:P]} Hectopascals")
      return u.to('millibars').scalar.to_f
    end

    def get_ozone_in_dobson(station, data, period)
      return nil
    end

    def get_dew_point_in_celcius(station, data, period)
      # TD = Dew point temperature (in 0.1 degrees Celsius) at 1.50 m at the
      # time of observation;
      return data[:TD]
    end
  end
end

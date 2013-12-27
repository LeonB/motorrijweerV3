module WeatherProviders::Abstract extend ActiveSupport::Testing::Declarative

  test "get_api_date should return hash" do
    station = stations(:kloosterzande)
    api_data = @provider.get_api_data(station)
    assert api_data.is_a?(Hash), "api_get_data doesn't return a Hash"
  end

  test "collect_data hash should contain all forecast model fields" do
    station = stations(:kloosterzande)
    api_data = @provider.get_api_data(station)
    processed_data= self.collect_hourly_data(station, api_data)

    WeatherProviders::WeatherProvider::FIELDS.each do |f|
      assert processed_data.has_key?(f.to_sym), "processed_data doesn't have key #{f}"
    end
  end

  test "collect_data should return right values" do
    station = stations(:kloosterzande)
    api_data = @provider.get_api_data(station)
    data = self.collect_hourly_data(station, api_data)

    assert data[:from_datetime].is_a?(DateTime)
    assert data[:to_datetime].is_a?(DateTime)
    assert data[:description].nil? == false
    assert data[:weather_type].nil? == false
    assert (data[:precipitation_type].is_a?(String) or
            data[:precipitation_type].nil?), ":precipitation_type is #{data[:precipitation_type].class}"
    assert (data[:precipitation_probability].is_a?(Float) or
            data[:precipitation_probability].nil?)
    assert (data[:precipitation_in_mm_per_hour_max].is_a?(Float) or
            data[:precipitation_in_mm_per_hour_max].nil?)
    assert (data[:precipitation_in_mm_per_hour_min].is_a?(Float) or
            data[:precipitation_in_mm_per_hour_min].nil?)
    assert data[:precipitation_in_mm_per_hour_avg].is_a?(Float)
    assert (data[:precipitation_accumulation_in_centimers_max].is_a?(Float) or
            data[:precipitation_accumulation_in_centimers_max].nil?)
    assert (data[:precipitation_accumulation_in_centimers_min].is_a?(Float) or
            data[:precipitation_accumulation_in_centimers_min].nil?)
    assert (data[:precipitation_accumulation_in_centimers_avg].is_a?(Float) or
            data[:precipitation_accumulation_in_centimers_avg].nil?)
    assert (data[:winter_precipitation_in_mm_per_hour_max].is_a?(Float) or
            data[:winter_precipitation_in_mm_per_hour_max].nil?)
    assert (data[:winter_precipitation_in_mm_per_hour_min].is_a?(Float) or
            data[:winter_precipitation_in_mm_per_hour_min].nil?)
    assert (data[:winter_precipitation_in_mm_per_hour_avg].is_a?(Float) or
            data[:winter_precipitation_in_mm_per_hour_avg].nil?)
    assert (data[:temperature_in_celcius_max].is_a?(Float) or
            data[:temperature_in_celcius_max].nil?)
    assert (data[:temperature_in_celcius_min].is_a?(Float) or
            data[:temperature_in_celcius_min].nil?)
    assert data[:temperature_in_celcius_avg].is_a?(Float)
    assert (data[:apparent_temperature_in_celcius_max].is_a?(Float) or
            data[:apparent_temperature_in_celcius_max].nil?)
    assert (data[:apparent_temperature_in_celcius_min].is_a?(Float) or
            data[:apparent_temperature_in_celcius_min].nil?)
    assert data[:apparent_temperature_in_celcius_avg].is_a?(Float)
    assert (data[:wind_speed_in_meters_per_second_max].is_a?(Float) or
            data[:wind_speed_in_meters_per_second_max].nil?)
    assert (data[:wind_speed_in_meters_per_second_min].is_a?(Float) or
            data[:wind_speed_in_meters_per_second_min].nil?)
    assert data[:wind_speed_in_meters_per_second_avg].is_a?(Float)
    assert (data[:wind_bearing_in_degrees_max].is_a?(Float) or
            data[:wind_bearing_in_degrees_max].nil?)
    assert (data[:wind_bearing_in_degrees_min].is_a?(Float) or
            data[:wind_bearing_in_degrees_min].nil?)
    assert data[:wind_bearing_in_degrees_avg].is_a?(Float)
    assert (data[:cloud_cover_max].is_a?(Float) or
            data[:cloud_cover_max].nil?)
    assert (data[:cloud_cover_min].is_a?(Float) or
            data[:cloud_cover_min].nil?)
    assert data[:cloud_cover_avg].is_a?(Float)
    assert (data[:pressure_in_millibars_max].is_a?(Float) or
            data[:pressure_in_millibars_max].nil?)
    assert (data[:pressure_in_millibars_min].is_a?(Float) or
            data[:pressure_in_millibars_min].nil?)
    assert data[:pressure_in_millibars_avg].is_a?(Float)
    assert (data[:visibility_in_meters_max].is_a?(Float) or
            data[:visibility_in_meters_max].nil?)
    assert (data[:visibility_in_meters_min].is_a?(Float) or
            data[:visibility_in_meters_min].nil?)
    assert (data[:visibility_in_meters_avg].is_a?(Float) or
            data[:visibility_in_meters_avg].nil?)
    assert (data[:ozone_in_dobson_max].is_a?(Float) or
            data[:ozone_in_dobson_max].nil?)
    assert (data[:ozone_in_dobson_min].is_a?(Float) or
            data[:ozone_in_dobson_min].nil?)
    assert (data[:ozone_in_dobson_avg].is_a?(Float) or
            data[:ozone_in_dobson_avg].nil?)
    assert (data[:dew_point_in_celcius_max].is_a?(Float) or
            data[:dew_point_in_celcius_max].nil?)
    assert (data[:dew_point_in_celcius_min].is_a?(Float) or
            data[:dew_point_in_celcius_min].nil?)
    assert (data[:dew_point_in_celcius_avg].is_a?(Float) or
            data[:dew_point_in_celcius_avg].nil?)
  end

  test "import_forecasts should return hash with results" do
    station = stations(:kloosterzande)
    results = @provider.import_forecasts(station)
    assert results.is_a?(Hash), "results should be a Hash"
    assert results.has_key?(:processed), "results has no key :processed"
    assert results.has_key?(:created), "results has no key :created"
    assert results.has_key?(:updated), "results has no key :updated"
    assert results.has_key?(:skipped), "results has no key :skipped"
  end

end

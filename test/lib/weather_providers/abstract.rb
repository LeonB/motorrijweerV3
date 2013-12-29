module WeatherProviders::Abstract extend ActiveSupport::Testing::Declarative

  test "get_api_date should return hash" do
    station = stations(:kloosterzande)
    api_data = @provider.get_api_data(station)
    assert api_data.is_a?(Hash), "api_get_data doesn't return a Hash"
  end

  test "collect_data hash should contain all forecast model fields" do
    station = stations(:kloosterzande)
    api_data = @provider.get_api_data(station)
    processed_data = @provider.collect_processed_hourly_data(station, api_data)
    first_item = processed_data.first

    WeatherProviders::WeatherProvider::FIELDS.each do |f|
      assert first_item.has_key?(f.to_sym), "processed_data doesn't have key #{f}"
    end
  end

  test "collect_data should return right values" do
    station = stations(:kloosterzande)
    api_data = @provider.get_api_data(station)
    processed_data = @provider.collect_processed_hourly_data(station, api_data)
    item = processed_data.first

    assert item[:from_datetime].is_a?(DateTime)
    assert item[:to_datetime].is_a?(DateTime)
    assert item[:period].in? ['minute', 'hour', 'day']
    assert item[:description].nil? == false
    assert item[:weather_type].nil? == false
    assert (item[:precipitation_type].is_a?(String) or
            item[:precipitation_type].nil?), ":precipitation_type is #{item[:precipitation_type].class}"
    assert (item[:precipitation_probability].is_a?(Numeric) or
            item[:precipitation_probability].nil?)
    assert (item[:precipitation_in_mm_per_hour_max].is_a?(Numeric) or
            item[:precipitation_in_mm_per_hour_max].nil?)
    assert (item[:precipitation_in_mm_per_hour_min].is_a?(Numeric) or
            item[:precipitation_in_mm_per_hour_min].nil?)
    assert item[:precipitation_in_mm_per_hour_avg].is_a?(Numeric)
    assert (item[:precipitation_accumulation_in_centimers_max].is_a?(Numeric) or
            item[:precipitation_accumulation_in_centimers_max].nil?)
    assert (item[:precipitation_accumulation_in_centimers_min].is_a?(Numeric) or
            item[:precipitation_accumulation_in_centimers_min].nil?)
    assert (item[:precipitation_accumulation_in_centimers_avg].is_a?(Numeric) or
            item[:precipitation_accumulation_in_centimers_avg].nil?)
    assert (item[:winter_precipitation_in_mm_per_hour_max].is_a?(Numeric) or
            item[:winter_precipitation_in_mm_per_hour_max].nil?)
    assert (item[:winter_precipitation_in_mm_per_hour_min].is_a?(Numeric) or
            item[:winter_precipitation_in_mm_per_hour_min].nil?)
    assert (item[:winter_precipitation_in_mm_per_hour_avg].is_a?(Numeric) or
            item[:winter_precipitation_in_mm_per_hour_avg].nil?)
    assert (item[:temperature_in_celcius_max].is_a?(Numeric) or
            item[:temperature_in_celcius_max].nil?)
    assert (item[:temperature_in_celcius_min].is_a?(Numeric) or
            item[:temperature_in_celcius_min].nil?)
    assert item[:temperature_in_celcius_avg].is_a?(Numeric)
    assert (item[:apparent_temperature_in_celcius_max].is_a?(Numeric) or
            item[:apparent_temperature_in_celcius_max].nil?)
    assert (item[:apparent_temperature_in_celcius_min].is_a?(Numeric) or
            item[:apparent_temperature_in_celcius_min].nil?)
    assert item[:apparent_temperature_in_celcius_avg].is_a?(Numeric)
    assert (item[:wind_speed_in_meters_per_second_max].is_a?(Numeric) or
            item[:wind_speed_in_meters_per_second_max].nil?)
    assert (item[:wind_speed_in_meters_per_second_min].is_a?(Numeric) or
            item[:wind_speed_in_meters_per_second_min].nil?)
    assert item[:wind_speed_in_meters_per_second_avg].is_a?(Numeric)
    assert (item[:wind_bearing_in_degrees_max].is_a?(Numeric) or
            item[:wind_bearing_in_degrees_max].nil?)
    assert (item[:wind_bearing_in_degrees_min].is_a?(Numeric) or
            item[:wind_bearing_in_degrees_min].nil?)
    assert item[:wind_bearing_in_degrees_avg].is_a?(Numeric)
    assert (item[:cloud_cover_max].is_a?(Numeric) or
            item[:cloud_cover_max].nil?)
    assert (item[:cloud_cover_min].is_a?(Numeric) or
            item[:cloud_cover_min].nil?)
    assert item[:cloud_cover_avg].is_a?(Numeric)
    assert (item[:pressure_in_millibars_max].is_a?(Numeric) or
            item[:pressure_in_millibars_max].nil?)
    assert (item[:pressure_in_millibars_min].is_a?(Numeric) or
            item[:pressure_in_millibars_min].nil?)
    assert item[:pressure_in_millibars_avg].is_a?(Numeric)
    assert (item[:visibility_in_meters_max].is_a?(Numeric) or
            item[:visibility_in_meters_max].nil?)
    assert (item[:visibility_in_meters_min].is_a?(Numeric) or
            item[:visibility_in_meters_min].nil?)
    assert (item[:visibility_in_meters_avg].is_a?(Numeric) or
            item[:visibility_in_meters_avg].nil?)
    assert (item[:ozone_in_dobson_max].is_a?(Numeric) or
            item[:ozone_in_dobson_max].nil?)
    assert (item[:ozone_in_dobson_min].is_a?(Numeric) or
            item[:ozone_in_dobson_min].nil?)
    assert (item[:ozone_in_dobson_avg].is_a?(Numeric) or
            item[:ozone_in_dobson_avg].nil?)
    assert (item[:dew_point_in_celcius_max].is_a?(Numeric) or
            item[:dew_point_in_celcius_max].nil?)
    assert (item[:dew_point_in_celcius_min].is_a?(Numeric) or
            item[:dew_point_in_celcius_min].nil?)
    assert (item[:dew_point_in_celcius_avg].is_a?(Numeric) or
            item[:dew_point_in_celcius_avg].nil?)
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

  test "import_forecasts should update result hash" do
    station = stations(:kloosterzande)
    @provider.import_forecasts(station)
    assert @provider.results.is_a?(Hash), "results should be a Hash"
    assert @provider.results.has_key?(:processed), "results has no key :processed"
    assert @provider.results.has_key?(:created), "results has no key :created"
    assert @provider.results.has_key?(:updated), "results has no key :updated"
    assert @provider.results.has_key?(:skipped), "results has no key :skipped"
  end

  test "collect_processed_hourly_data should contain forecasts with precipitation_probability > 0" do
    station = stations(:kloosterzande)
    api_data = @provider.get_api_data(station)
    processed_data = @provider.collect_processed_hourly_data(station, api_data)
    assert processed_data.select { |d| d[:precipitation_probability] > 0 }.count > 0
  end

  test "collect_processed_hourly_data should contain forecasts with wind_bearing > 0" do
    station = stations(:kloosterzande)
    api_data = @provider.get_api_data(station)
    processed_data = @provider.collect_processed_hourly_data(station, api_data)
    assert processed_data.select { |d| d[:wind_bearing_in_degrees_avg] > 0 }.count > 0
  end

end

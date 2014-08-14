require 'test_helper'

class ForecastTest < ActiveSupport::TestCase
  test "temperature_in_fahrenheit_avg should do the right conversion" do
    f = Forecast.new
    f.temperature_in_celcius_avg = 20
    assert_equal 68, f.temperature_in_fahrenheit_avg.round

    f.temperature_in_celcius_avg = -20
    assert_equal -4, f.temperature_in_fahrenheit_avg.round
  end

  test "wind_speed_in_miles_per_hour_max should do the right conversion" do
    f = Forecast.new
    f.wind_speed_in_meters_per_second_max = 0
    assert_equal 0, f.wind_speed_in_miles_per_hour_max.round

    f.wind_speed_in_meters_per_second_max = 20
    assert_equal 44.74, f.wind_speed_in_miles_per_hour_max.round(2)
  end

  test "wind_speed_in_miles_per_hour_min should do the right conversion" do
    f = Forecast.new
    f.wind_speed_in_meters_per_second_min = 0
    assert_equal 0, f.wind_speed_in_miles_per_hour_min.round

    f.wind_speed_in_meters_per_second_min = 20
    assert_equal 44.74, f.wind_speed_in_miles_per_hour_min.round(2)
  end

  test "wind_speed_in_miles_per_hour_avg should do the right conversion" do
    f = Forecast.new
    f.wind_speed_in_meters_per_second_avg = 0
    assert_equal 0, f.wind_speed_in_miles_per_hour_avg.round

    f.wind_speed_in_meters_per_second_avg = 20
    assert_equal 44.74, f.wind_speed_in_miles_per_hour_avg.round(2)
  end

  test "calculate_apparent_temperature_in_celcius_max should do the right conversion" do
    f = Forecast.new
    f.temperature_in_celcius_max = 0
    f.wind_speed_in_meters_per_second_min = 0
    f.humidity_max = 0
    assert_equal 0, f.calculate_apparent_temperature_in_celcius_max.round(2)

    f.temperature_in_celcius_max = 20
    f.wind_speed_in_meters_per_second_min = 20
    f.humidity_max = 60
    assert_equal 20, f.calculate_apparent_temperature_in_celcius_max.round(2)

    f.temperature_in_celcius_max = -20
    f.wind_speed_in_meters_per_second_min = 20
    f.humidity_max = 20
    assert_equal -37.53, f.calculate_apparent_temperature_in_celcius_max.round(2)
  end

  test "calculate_apparent_temperature_in_celcius_min should do the right conversion" do
    f = Forecast.new
    f.temperature_in_celcius_min = 0
    f.wind_speed_in_meters_per_second_max = 0
    f.humidity_min = 0
    assert_equal 0, f.calculate_apparent_temperature_in_celcius_min.round(2)

    f.temperature_in_celcius_min = 20
    f.wind_speed_in_meters_per_second_max = 20
    f.humidity_min = 60
    assert_equal 20, f.calculate_apparent_temperature_in_celcius_min.round(2)

    f.temperature_in_celcius_min = -20
    f.wind_speed_in_meters_per_second_max = 20
    f.humidity_min = 20
    assert_equal -37.53, f.calculate_apparent_temperature_in_celcius_min.round(2)
  end

  test "calculate_apparent_temperature_in_celcius_avg should do the right conversion" do
    f = Forecast.new
    f.temperature_in_celcius_avg = 0
    f.wind_speed_in_meters_per_second_avg = 0
    f.humidity_avg = 0
    assert_equal 0, f.calculate_apparent_temperature_in_celcius_avg.round(2)

    f.temperature_in_celcius_avg = 20
    f.wind_speed_in_meters_per_second_avg = 20
    f.humidity_avg = 60
    assert_equal 20, f.calculate_apparent_temperature_in_celcius_avg.round(2)

    f.temperature_in_celcius_avg = -20
    f.wind_speed_in_meters_per_second_avg = 20
    f.humidity_avg = 20
    assert_equal -37.53, f.calculate_apparent_temperature_in_celcius_avg.round(2)
  end

end

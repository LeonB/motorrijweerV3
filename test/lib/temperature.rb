require 'test_helper'

class TemperatureTest < ActiveSupport::TestCase

  test "wind_chill_calculation_should_be_right" do
    values = {
      [40, 10] => 33.64,
      [40, 20] => 30.48,
      [40, 30] => 28.46,
      [40, 40] => 26.95,
      [30, 10] => 21.25,
      [30, 20] => 17.36,
      [30, 30] => 14.88,
      [30, 40] => 13.02,
      [20, 10] => 8.85,
      [20, 20] => 4.24,
      [20, 30] => 1.30,
      [20, 40] => -0.91,
      [10, 10] => -3.54,
      [10, 20] => -8.88,
      [10, 30] => -12.28,
      [10, 40] => -14.84,
    }

    values.each do |k, v|
      assert_equal Temperature.wind_chill(k.first, k.last).round(2), v
    end
  end

  test "heat_index_calculation_should_be_right" do
    values = {
      [80, 0.4] => 79.93,
      [90, 0.4] => 90.68,
      [100, 0.4] => 109.26,
      [110, 0.4] => 135.66,
      [80, 0.5] => 80.8,
      [90, 0.5] => 94.6,
      [100, 0.5] => 118.32,
      [110, 0.5] => 151.96,
      [80, 0.6] => 81.81,
      [90, 0.6] => 99.68,
      [100, 0.6] => 129.49,
      [110, 0.6] => 171.24,
      [80, 0.7] => 82.95,
      [90, 0.7] => 105.92,
      [100, 0.7] => 142.78,
      [110, 0.7] => 193.51,
      [80, 0.8] => 84.23,
      [90, 0.8] => 113.33,
      [100, 0.8] => 158.17,
      [110, 0.8] => 218.76,
      [80, 0.9] => 85.64,
      [90, 0.9] => 121.90,
      [100, 0.9] => 175.69,
      [110, 0.9] => 247.00,
      [80, 1] => 87.19,
      [90, 1] => 131.64,
      [100, 1] => 195.31,
      [110, 1] => 278.21,
    }

    values.each do |k, v|
      assert_equal Temperature.heat_index(k.first, k.last).round(2), v
    end
  end

  test "apparent_temperature should use heat_index when t >= 80 and r >= 0.4" do
    t = 80
    a = 0
    r = 0.4
    assert_equal(
      Temperature.heat_index(t, r),
      Temperature.apparent_temperature(t, a, r)
    )
  end

  test "apparent_temperature should use air temperature when t >= 80 and r < 0.4" do
    t = 80
    a = 0
    r = 0.3
    assert_equal(
      t,
      Temperature.apparent_temperature(t, a, r)
    )
  end

  test "apparent_temperature should use wind_chill when t <= 40 and a >= 3" do
    t = 40
    a = 3
    r = 0.4
    assert_equal(
      Temperature.wind_chill(t, a),
      Temperature.apparent_temperature(t, a, r)
    )
  end

  test "apparent_temperature should use air temperature when t <= 40 and a < 3" do
    t = 80
    a = 2
    r = 0
    assert_equal(
      t,
      Temperature.apparent_temperature(t, a, r)
    )
  end

  test "apparent_temperature should use air temperature when t == 60" do
    t = 60
    a = 99
    r = 1.0
    assert_equal(
      t,
      Temperature.apparent_temperature(t, a, r)
    )
  end
end

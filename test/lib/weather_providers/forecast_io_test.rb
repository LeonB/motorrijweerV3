require 'test_helper'
require 'lib/weather_providers/abstract'

class WeatherProviders::ForecastIoTest < ActiveSupport::TestCase
  include WeatherProviders::Abstract

  def setup
    register_api_url_stubs
    @provider = WeatherProviders::ForecastIo.new
  end

  def register_api_url_stubs
    WebMock::stub_request(:get, 'https://api.forecast.io/forecast/9ccd69acf062e01564240edd8a71f3d2/51.36573,4.010793?exclude=minutely,daily,alerts,flags&extend=hourly&units=si').
      to_return(:body => File.new('test/fixtures/http_requests/forecast_io/forecast/kloosterzande.json'))
  end

  def collect_hourly_data(station, api_data)
    @provider.collect_data(station, api_data.hourly.data.first, WeatherProviders::WeatherProvider::PERIOD_HOUR)
  end

  test "get_api_date should contain hourly info" do
    station = stations(:kloosterzande)
    api_data = @provider.get_api_data(station)
    assert api_data.is_a?(Hash), "api_get_data doesn't return a Hash"
    assert api_data.has_key?(:hourly), "api_get_data doesn't contain hourly data"
  end

end

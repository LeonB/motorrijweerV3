require 'test_helper'
require 'lib/weather_providers/abstract'

class WeatherProviders::WeatherUndergroundTest < ActiveSupport::TestCase
  include WeatherProviders::Abstract

  def setup
    register_api_url_stubs
    @provider = WeatherProviders::WeatherUnderground.new
  end

  def register_api_url_stubs
    WebMock::stub_request(:get, 'http://api.wunderground.com/api/924da7bebb43ef5a/hourly10day/lang:NL/q/51.36573,4.010793.json').
      to_return(:body => File.new('test/fixtures/http_requests/weather_underground/hourly10day/kloosterzande.json'))
  end

  test "get_api_date should contain hourly info" do
    station = stations(:kloosterzande)
    api_data = @provider.get_api_data(station)
    assert api_data.is_a?(Hash), "api_get_data doesn't return a Hash"
    assert api_data.has_key?('hourly_forecast'), "api_get_data doesn't contain hourly data"
  end

end

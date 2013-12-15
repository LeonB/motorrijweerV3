require 'test_helper'

class WeatherProviders::ForecastIoTest < ActiveSupport::TestCase

  def setup
    register_api_url_stubs
  end

  def register_api_url_stubs
  end

  test "the truth" do
    WeatherProviders::WeatherUnderground.new
    assert true
  end

end


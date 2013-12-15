require 'test_helper'

class WeatherProviders::WeatherproviderTest < ActiveSupport::TestCase
  test "the truth" do
    WeatherProviders::WeatherUnderground.new
    assert true
  end
end

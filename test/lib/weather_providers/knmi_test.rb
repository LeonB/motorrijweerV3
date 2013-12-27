require 'test_helper'

class WeatherProviders::KNMITest < ActiveSupport::TestCase

  def setup
    register_api_url_stubs
  end

  def register_api_url_stubs
  end

  test "the truth" do
    WeatherProviders::KNMI.new
    assert true
  end

end

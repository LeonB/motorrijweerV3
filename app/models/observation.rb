class Observation < ActiveRecord::Base
  belongs_to :station

  validates_presence_of :station
  validates_presence_of :provider
  # Also validate zone?
  validates_presence_of :from_datetime
  validates_presence_of :to_datetime

  def temperature_in_fahrenheit
      u = Unit.new("#{self.temperature_in_celcius} tempC")
      u.to('tempF').scalar.to_f
  end

  def wind_speed_in_miles_per_hour
    u = Unit.new("#{self.wind_speed_in_meters_per_second} m/s")
    u.to('mph').scalar.to_f
  end

  def calculate_apparent_temperature_in_celcius
    t = self.temperature_in_fahrenheit
    a = self.wind_speed_in_miles_per_hour
    r = self.humidity

    return nil if t.nil? or a.nil? or r.nil?
    t = Temperature.apparent_temperature(t, a, r)
    u = Unit.new("#{t} tempF")
    u.to('tempC').scalar.to_f
  end
end

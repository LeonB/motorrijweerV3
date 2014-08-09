class Forecast < ActiveRecord::Base
  belongs_to :station
  [
    :apparent_temperature_in_celcius,
    :cloud_cover,
    :precipitation_in_mm_per_hour,
    :temperature_in_celcius
  ].each do |field|
    validates_presence_of :"#{field}_avg", {
      :unless => (:"#{field}_min?" and :"#{field}_max?"),
      :message => "#{field} can't be blank"
    }
  end
  # validates_presence_of :precipitation_probability
  validates_presence_of :station
  validates_presence_of :provider
  # Also validate zone?
  validates_presence_of :from_datetime
  validates_presence_of :to_datetime

  def temperature_in_fahrenheit_max
      u = Unit.new("#{self.temperature_in_celcius_max} tempC")
      u.to('tempF').scalar.to_f
  end

  def temperature_in_fahrenheit_min
      u = Unit.new("#{self.temperature_in_celcius_min} tempC")
      u.to('tempF').scalar.to_f
  end

  def temperature_in_fahrenheit_avg
      u = Unit.new("#{self.temperature_in_celcius_avg} tempC")
      u.to('tempF').scalar.to_f
  end

  # def calculate_heat_index_in_celcius_avg
  #   t = self.temperature_in_fahrenheit_avg
  #   r = self.humidity_avg
  #   hi = HeatIndex.calculate(t, r)
  #   u = Unit.new("#{hi} tempF")
  #   u.to('tempC').scalar.to_f
  # end

  # def calculate_wind_chill_in_celcius_avg
  #   t = self.temperature_in_fahrenheit_avg
  #   a = self.wind_speed_in_miles_per_hour_avg
  #   wc = WindChill.calculate(t, a)
  #   u = Unit.new("#{wc} tempF")
  #   u.to('tempC').scalar.to_f
  # end

  def wind_speed_in_miles_per_hour_max
    u = Unit.new("#{self.wind_speed_in_meters_per_second_max} m/s")
    u.to('mph').scalar.to_f
  end

  def wind_speed_in_miles_per_hour_min
    u = Unit.new("#{self.wind_speed_in_meters_per_second_min} m/s")
    u.to('mph').scalar.to_f
  end

  def wind_speed_in_miles_per_hour_avg
    u = Unit.new("#{self.wind_speed_in_meters_per_second_avg} m/s")
    u.to('mph').scalar.to_f
  end

  def wind_speed_in_kilometers_per_hour_avg
    u = Unit.new("#{self.wind_speed_in_meters_per_second_avg} m/s")
    u.to('km/h').scalar.to_f
  end

  def calculate_apparent_temperature_in_celcius_max
    t = self.temperature_in_fahrenheit_max
    a = self.wind_speed_in_miles_per_hour_min
    r = self.humidity_max

    return nil if t.nil? or a.nil? or r.nil?
    t = Temperature.apparent_temperature(t, a, r)
    u = Unit.new("#{t} tempF")
    u.to('tempC').scalar.to_f
  end

  def calculate_apparent_temperature_in_celcius_min
    t = self.temperature_in_fahrenheit_min
    a = self.wind_speed_in_miles_per_hour_max
    r = self.humidity_min

    return nil if t.nil? or a.nil? or r.nil?
    t = Temperature.apparent_temperature(t, a, r)
    u = Unit.new("#{t} tempF")
    u.to('tempC').scalar.to_f
  end

  def calculate_apparent_temperature_in_celcius_avg
    t = self.temperature_in_fahrenheit_avg
    a = self.wind_speed_in_miles_per_hour_avg
    r = self.humidity_avg

    return nil if t.nil? or a.nil? or r.nil?
    t = Temperature.apparent_temperature(t, a, r)
    u = Unit.new("#{t} tempF")
    u.to('tempC').scalar.to_f
  end

end

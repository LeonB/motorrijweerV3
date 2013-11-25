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
  validates_presence_of :precipitation_probability
  validates_presence_of :station
  validates_presence_of :provider
end

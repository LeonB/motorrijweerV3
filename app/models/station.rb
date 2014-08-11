class Station < ActiveRecord::Base
  belongs_to :region
  has_many :forecasts
  has_many :observations

  reverse_geocoded_by :latitude, :longitude
  # after_validation :reverse_geocode  # auto-fetch address

  scope :knmi, -> { where("lower(name) IN (?)",
                          self.knmi_stations.map(&:name).map(&:downcase))}

  def self.knmi_stations
    # From KNMI gem
    KNMI::Station.send(:stations)
  end

  def knmi_id
    Station.knmi_stations.each do |knmi_station|
      if self.name.downcase == knmi_station.name.downcase
        return knmi_station.id
      end
    end

    # nothing matches: return nil
    return nil
  end

  def knmi_station
    knmi_id = self.knmi_id
    return nil if not knmi_id
    return KNMI.station_by_id(knmi_id)
  end
end

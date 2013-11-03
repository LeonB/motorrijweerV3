class Station < ActiveRecord::Base
  belongs_to :region
  reverse_geocoded_by :latitude, :longitude
  # after_validation :reverse_geocode  # auto-fetch address
end

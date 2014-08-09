class Observation < ActiveRecord::Base
  belongs_to :station

  validates_presence_of :station
  validates_presence_of :provider
  # Also validate zone?
  validates_presence_of :from_datetime
  validates_presence_of :to_datetime
end

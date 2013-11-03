class Region < ActiveRecord::Base
  has_many :stations
  belongs_to :region
  has_many :regions, :foreign_key => :parent_id, :dependent => :delete_all
  acts_as_nested_set
  before_save :setup_code

  def setup_code
    self.code = self.name.downcase.gsub(/-/, '')
  end
end

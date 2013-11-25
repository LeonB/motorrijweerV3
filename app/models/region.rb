class Region < ActiveRecord::Base
  has_many :stations
  belongs_to :parent, :class_name => Region, :foreign_key => :parent_id
  has_many :regions, :foreign_key => :parent_id, :dependent => :delete_all
  acts_as_nested_set
  before_validation { self.code = self.generate_code}

  # Auto generate the code value
  # The code is based on <tt>name</tt> and stripped from all non-alphanumberic characters
  # <tt>Code</tt> is used for slugs (?)
  def generate_code
    self.name.downcase.gsub(/[^\w]/, '')
  end
end

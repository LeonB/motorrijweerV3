class Region < ActiveRecord::Base
  acts_as_nested_set
  before_save :setup_code

  def setup_code
    self.code = self.name.downcase.gsub(/-/, '')
  end
end

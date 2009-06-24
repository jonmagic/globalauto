class Technician < ActiveRecord::Base
  has_many :jobs
  has_many :timeclocks
  
  validates_presence_of :name, :code, :color
  validates_length_of :code, :within => 3..20
  
  def self.active_techs
    find(:all, :conditions => {:active => true})
  end
  
end

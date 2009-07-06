class Technician < ActiveRecord::Base
  has_many :jobs
  
  validates_presence_of :name, :color
  validates_length_of :code, :within => 3..20
  
  def self.active_techs
    find(:all, :conditions => {:active => true})
  end
  
  def has_jobs?
    self.open_jobs.length != 0
  end
  
  def open_jobs
    technician = self
    Job.scoped_by_technician_id(self.id).scoped_by_completed(nil)
  end
  
end

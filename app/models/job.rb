class Job < ActiveRecord::Base
  has_many :timeclocks
  belongs_to :technician
  
  validates_presence_of :ro_number, :description, :technician_id, :clients_lastname
  validates_length_of :clients_lastname, :within => 2..40
  
  def self.active_jobs
    find(:all, :conditions => {:completed => nil})
  end
  
  def self.my_jobs(technician)
    find(:all, :conditions => {:completed => nil})
  end
  
  def status
    self.timeclocks.each do |timeclock|
      status = timeclock.status
    end 
  end
  
end

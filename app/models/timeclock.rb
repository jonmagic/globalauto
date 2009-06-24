class Timeclock < ActiveRecord::Base
  belongs_to :job
  belongs_to :technician
  
  validates_presence_of :job_id, :technician_id
  attr_protected :start_time, :end_time
  
  before_create :start_time
  
  def start_time
    self.start_time = Time.now
  end
  
  def end
    self.end_time = Time.now
  end
  
  def status
    if self.start_time != nil and self.end_time == nil
      return "Started"
    elsif self.start_time != nil and self.end_time != nil
      return "Finished"
    else
      return "Broken"
    end
  end
  
end

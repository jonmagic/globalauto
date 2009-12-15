class Timer < ActiveRecord::Base
  belongs_to :job
  
  validates_presence_of :job_id
  attr_protected :start_time, :end_time
  
  before_create :set_start_time
  before_update :set_end_time
  
  def set_start_time
    self.start_time = Time.now
  end
  
  def set_end_time
    self.end_time = Time.now
  end
  
  def interval
    if self.end_time
      time = self.end_time - self.start_time
    else
      time = Time.now - self.start_time
    end
    return time
  end
  
  def running
    self.end_time == nil
  end
  
  def self.convert_time(time)
    time < 0 ? positive = false : positive = true
    new_time = time.abs
    new_time = new_time.to_i
    hours = (new_time/60)
    minutes = (new_time - hours*60)
    if minutes >= 10
      minutes = minutes.to_s
    else
      minutes = (minutes.to_f/100).to_s[2..3]
    end
    hash = {}
    hash["positive"] = positive
    hash["hours"], hash["minutes"], hash["hours_and_minutes"], hash["hours_and_hundredths"] = hours.to_s, minutes, hours.to_s+":"+minutes, time.to_s
    return hash
  end
  
end

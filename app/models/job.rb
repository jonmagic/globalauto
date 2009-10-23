class Job < ActiveRecord::Base
  has_many :timers
  belongs_to :technician
  
  validates_presence_of :ro_number, :description, :technician_id, :clients_lastname
  validates_length_of :clients_lastname, :within => 2..40
  
  after_create :start_initial_timer
  after_update :stop_timers_if_completed
  
  def start_initial_timer
    Timer.create(:job_id => self.id)
  end
  
  def stop_timers_if_completed
    if self.completed != nil
      self.timers.each do |timer|
        if timer.end_time == nil
          timer.update_attributes(:end_time => Time.now)
        end
      end
    end
  end
  
  def self.active_jobs
    find(:all, :conditions => {:completed => nil})
  end

  def status
    key = 0
    self.timers.each do |timer|
      if timer.running
        key += 1
      end
    end
    if key > 0
      return "Running"
    else
      return "Stopped"
    end
  end
  
  def has_had_a_timer?
    trigger = 0
    self.timers.each do |timer|
      if timer.end_time != nil
        trigger += 1
      end
    end
    trigger > 0
  end
  
  def last_timer
    Timer.last(:conditions => {:job_id => self.id})
  end
  
  def recorded_time_helper
    time = 0
    self.timers.each do |timer|
      time += timer.interval
    end
    return time.to_f/60
  end
  
  def difference
    self.recorded_time.to_f - (self.flatrate_time.to_f + self.extra_time.to_f)
  end
  
  def self.totals
    past = Date.today - 100.years
    future = Date.today + 100.years
    totals = {}
    open = {:completed => nil}
    completed = {:completed => past..future, :flatrate_time => nil}
    totals[:open]    = (self.find(:all, :conditions => open)).length
    totals[:completed]  = (self.find(:all, :conditions => completed)).length
    return totals
  end
  
  def self.limit(status, technician_id="all")
    past = Date.today - 100.years
    future = Date.today + 100.years
    find :all do
      all do
        if status == nil || status == "completed"
          completed <=> (past..future)
          flatrate_time  == ""
        elsif status == "open"
          completed == nil
        elsif status == "recorded"
          flatrate_time >= 0
          completed.not.nil?
        end
      end
    end
  end
  
  def self.first_completed_job
    past = Date.today - 100.years
    future = Date.today + 100.years
    self.first(:conditions => {:completed => past..future, :flatrate_time => nil})
  end
  
  
end

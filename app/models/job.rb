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
    self.timers.each do |timer|
      if timer.end_time == nil
        timer.update_attributes(:end_time => Time.now)
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
    Timer.find(:last, :conditions => {:job_id => self.id})
  end
  
  def total_time_logged
    time = 0
    self.timers.each do |timer|
      if timer.end_time
        time += timer.end_time - timer.start_time
      else
        time += Time.now - timer.start_time
      end
    end
    return (time/60).round
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
  
  def self.limit(status)
    past = Date.today - 100.years
    future = Date.today + 100.years
    if status == nil || status == "completed"
      conditions = {:completed => past..future, :flatrate_time => nil}
    elsif status == "open"
      conditions = {:completed => nil}
    elsif status == "recorded"
      conditions = ["flatrate_time >= ?", 0]
    end
    self.all(:conditions => conditions)
  end
  
  def self.first_completed_job
    past = Date.today - 100.years
    future = Date.today + 100.years
    self.first(:conditions => {:completed => past..future, :flatrate_time => nil})
  end
  
  
end

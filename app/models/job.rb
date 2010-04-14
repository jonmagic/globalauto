class Job
  include MongoMapper::Document
  include MultiParameterAttributes
  
  key :ro, Integer, :required => true, :unique => true
  key :description, String, :required => true
  key :lastname, String, :required => true
  key :flatrate_time, Float
  key :extra_time, Integer
  key :technician_id, ObjectId, :required => true
  key :scheduled_at, Time
  key :completed_at, Time
  many :timers

  belongs_to :technician

  # after_update :stop_timers_if_completed
  # 
  # def stop_timers_if_completed
  #   if self.completed_at != nil
  #     self.timers.each do |timer|
  #       if timer.end_time == nil
  #         timer.update_attributes(:end_time => Time.zone.now)
  #       end
  #     end
  #   end
  # end
  
  # def self.active_jobs
  #   all(:completed_at => nil)
  # end

  # def status
  #   if self.timers.length == 0
  #     "New"
  #   elsif self.completed_at.blank?
  #     key = 0
  #     self.timers.each do |timer|
  #       if timer.running
  #         key += 1
  #       end
  #     end
  #     if key > 0
  #       return "Running"
  #     else
  #       return "Stopped"
  #     end
  #   else
  #     return "Completed"
  #   end
  # end

  # def has_had_a_timer?
  #   self.timers.length > 0
  # end

  # def last_timer
  #   self.timers.last
  # end

  # def recorded_time_helper
  #   time = 0
  #   self.timers.each do |timer|
  #     time += timer.interval
  #   end
  #   return (time.seconds.hours*100).to_i.to_f/100
  # end
  
  # def difference
  #   self.recorded_time.to_f - (self.flatrate_time.to_f + self.extra_time.to_f)
  # end

  # def self.totals
  #   past = Date.today - 100.years
  #   future = Date.today + 100.years
  #   totals = {}
  # 
  #   open = {:completed => nil}
  #   totals[:open]    = (self.all(:conditions => open)).length
  # 
  #   completed = {:completed => past..future, :flatrate_time => ""}
  #   totals[:completed]  = (self.all(:conditions => completed)).length
  # 
  #   recorded = find :all do
  #     all do
  #       flatrate_time >= 0
  #       # completed.not.nil?
  #     end
  #   end
  #   totals[:recorded] = recorded.length
  #   return totals
  # end

  # def self.limit(status, technician_id="all")
  #   past = Date.today - 100.years
  #   future = Date.today + 100.years
  #   find :all do
  #     all do
  #       if status == nil || status == "completed"
  #         completed <=> (past..future)
  #         flatrate_time  == ""
  #       elsif status == "open"
  #         completed == nil
  #       elsif status == "recorded"
  #         flatrate_time >= 0
  #         completed.not.nil?
  #       end
  #     end
  #   end
  # end
  # 
  # def self.first_completed_job
  #   past = Date.today - 100.years
  #   future = Date.today + 100.years
  #   self.first(:conditions => {:completed => past..future, :flatrate_time => ""})
  # end

end

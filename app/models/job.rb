class Job
  include MongoMapper::Document
  include MultiParameterAttributes
  
  key :ro, Integer
  key :lastname, String, :required => true
  key :vehicle, String
  key :description, String
  key :flatrate_time, Float
  key :extra_time, Float
  key :technician_id, ObjectId, :required => true
  key :scheduled_at, Time
  key :completed_at, Time
  many :timers

  belongs_to :technician

  state_machine :state, :initial => :scheduled do
    
    before_transition any => :in_progress do |job|
      job.timers << Timer.new(:start_time => Time.now)
    end
    
    before_transition :in_progress => [:pause, :complete] do |job|
      job.timers.last.update_attributes(:end_time => Time.now)
    end
    
    before_transition any => :complete do |job|
      job.completed_at = Time.now
    end
    
    before_transition :scheduled => :no_show do |job|
      job.flatrate_time = 0.45
    end
    
    event :arrived do
      transition :scheduled => :here
    end
    
    event :no_show do
      transition :scheduled => :no_show
    end
    
    event :toggle do
      transition :here => :in_progress, :in_progress => :pause, :pause => :in_progress
    end
    
    event :complete do
      transition :in_progress => :complete, :pause => :complete
    end
  end
  
  def recorded_time_helper
    recorded = 0
    self.timers.each do |t|
      unless t.start_time.blank?
        time = t.end_time.blank? ? Time.now - t.start_time : t.end_time - t.start_time
        recorded += time.round.seconds.hours
      end
    end
    return (recorded*100).to_i.to_f/100
  end
  
  def difference
    self.recorded_time_helper.to_f - (self.flatrate_time.to_f + self.extra_time.to_f)
  end
  
  def intersection
    time = 0
    job = self
    lunchtime = job.scheduled_at.midnight + 12.hours
    if job.scheduled_at < lunchtime && job.scheduled_at + (job.flatrate_time * 1.hours) > lunchtime
      time += 60
    end
    Job.where(:flatrate_time.ne => nil, :technician_id => job.technician_id).all.each do |j|
      if job.scheduled_at < j.scheduled_at && job.scheduled_at + (job.flatrate_time * 1.hours) > j.scheduled_at + (j.flatrate_time * 1.hours)
        time += j.flatrate_time * 60
      end
      job.flatrate_time += j.flatrate_time
    end
    time
  end
  
  def self.limit(status)
    array = []
    if status == "open"
      Job.all(:state => "arrived").each {|j| array << j}
      Job.all(:state => "in_progress").each {|j| array << j}
      Job.all(:state => "pause").each {|j| array << j}
    elsif status == "completed"
      Job.all(:state => "complete", :flatrate_time => nil).each {|j| array << j}
    elsif status == "recorded"
      Job.all(:state => "complete", :flatrate_time => {'$gt' => 0.0}).each {|j| array << j}
    end
    return array
  end
  
end

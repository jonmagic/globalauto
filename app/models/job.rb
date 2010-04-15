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
    return recorded
  end
  
end

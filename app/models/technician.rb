class Technician
  include MongoMapper::Document

  key :name, String, :required => true, :unique => true
  key :color, String, :required => true
  key :font_color, String, :required => true
  key :destroyed_at, Time

  alias :destroy_technician :destroy
  def destroy
    update_attributes(:destroyed_at => Time.zone.now) unless destroyed_at?
  end

  def has_jobs?
    self.open_jobs.length != 0
  end

  def jobs
    Job.all(:technician_id => self.id)
  end

  def open_jobs
    Job.all(:technician_id => self.id, :completed_at => nil)
  end

end

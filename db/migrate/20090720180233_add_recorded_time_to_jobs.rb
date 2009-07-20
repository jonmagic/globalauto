class AddRecordedTimeToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :recorded_time, :string
    Job.all.each do |job|
      job.update_attributes(:recorded_time => job.recorded_time_helper)
    end
  end

  def self.down
    remove_column :jobs, :recorded_time
  end
end

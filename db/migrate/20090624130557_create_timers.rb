class CreateTimers < ActiveRecord::Migration
  def self.up
    create_table :timers do |t|
      t.integer :job_id
      t.datetime :start_time
      t.datetime :end_time
    end
  end

  def self.down
    drop_table :timers
  end
end

class CreateTimeclocks < ActiveRecord::Migration
  def self.up
    create_table :timeclocks do |t|
      t.integer :job_id
      t.integer :technician_id
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end

  def self.down
    drop_table :timeclocks
  end
end

class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.integer :ro_number
      t.text :description
      t.integer :technician_id
      t.datetime :completed
      t.string :clients_lastname

      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end

class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :login
      t.string :hashed_password
      t.string :salt
      t.boolean :admin
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end

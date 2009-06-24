class Job < ActiveRecord::Base
  has_many :timeclocks
  belongs_to :technician
  
  validates_presence_of :ro_number, :description, :technician_id, :clients_lastname
  validates_length_of :clients_lastname, :within => 2..40
  
end

require 'test_helper'

class JobTest < ActiveSupport::TestCase
  should_belong_to :technician
  should_have_many :timeclocks
  
  should_validate_presence_of :ro_number, :description, :technician_id, :clients_lastname
  should_ensure_length_at_least :clients_lastname, 2
  
  
end

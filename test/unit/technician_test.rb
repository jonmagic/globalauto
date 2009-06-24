require 'test_helper'

class TechnicianTest < ActiveSupport::TestCase
  should_have_many :jobs
  should_have_many :timeclocks
  
  should_validate_presence_of :name, :code, :color
  should_ensure_length_at_least :code, 3
  
  context "active_techs" do
    setup do
      @greg = Factory.create(:greg)
      @tom = Factory.create(:tom)
      @technicians = Technician.active_techs
    end

    should "only return active techs" do
      assert_equal @technicians.length, 1
    end
  end
  

end

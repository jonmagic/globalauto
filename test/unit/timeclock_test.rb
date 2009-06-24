require 'test_helper'

class TimeclockTest < ActiveSupport::TestCase
  should_belong_to :job
  should_belong_to :technician
  
  should_protect_attributes :start_time, :end_time
  should_validate_presence_of :job_id, :technician_id
  
  context "creation" do
    setup do
      @timeclock = Factory.create(:timeclock)
    end

    should "set start_time" do
      assert @timeclock.start_time != nil
    end
  end
  
  context "update" do
    setup do
      @timeclock = Factory.create(:timeclock)
      @timeclock.end
    end

    should "set end_time" do
      @timeclock.end_time != nil
    end
  end
  
  context "status" do
    setup do
      @timeclock = Factory.create(:timeclock)
    end

    should "return Started when start_time is set and end_time is not" do
      assert_equal @timeclock.status, "Started"
    end
    should "return Finished when start_time is set and end_time is not" do
      @timeclock.end
      assert_equal @timeclock.status, "Finished"
    end
  end
  
  
  
end

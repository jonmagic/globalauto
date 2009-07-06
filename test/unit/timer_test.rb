require 'test_helper'

class TimerTest < ActiveSupport::TestCase
  should_belong_to :job
  
  should_protect_attributes :start_time, :end_time
  should_validate_presence_of :job_id
  
  context "creation" do
    setup do
      @timer = Factory.create(:timer)
    end

    should "set start_time" do
      assert @timer.start_time != nil
    end
  end
  
  context "update" do
    setup do
      @timer = Factory.create(:timer)
      @timer.update_attributes(:job_id => @timer.job_id)
    end

    should "set end_time" do
      @timer.end_time != nil
    end
  end
  
end

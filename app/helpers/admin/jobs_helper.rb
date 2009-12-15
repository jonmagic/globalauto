module Admin::JobsHelper

  def totals_helper(status)
    if @totals[status].to_i > 0
      return "<span class='totals'>#{@totals[status]}</span>"
    end
  end
  
  def status_helper(job)
    job.status
  end
  
  def time_helper(time)
    if Timer.convert_time(time.to_f)["positive"]
      Timer.convert_time(time.to_f)["hours_and_minutes"]
    else
      "-"+Timer.convert_time(time.to_f)["hours_and_minutes"]
    end
  end
  
  def time_hours_helper(time=nil)
    if time
      return Timer.convert_time(time.to_f)["hours"]
    else
      return "0"
    end
  end
  
  def time_minutes_helper(time=nil)
    if time
      return Timer.convert_time(time.to_f)["minutes"]
    else
      return "0"
    end
  end
  
  def running_difference(time)
    @runningdiff << time
    total = 0
    @runningdiff.each {|i| total += i}
    return total
  end
    
  def show_edit_helper(job)
    job.flatrate_time.blank? ? "/edit" : ""
  end
  
  
end

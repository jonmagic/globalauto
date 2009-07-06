module Admin::JobsHelper

  def totals_helper(status)
    if @totals[status].to_i > 0
      return "<span class='totals'>#{@totals[status]}</span>"
    end
  end
  
  def status_helper(job)
    job.status
  end
  
  def recorded_time_helper(job)
    time = 0
    job.timers.each do |timer|
      time += timer.interval
    end
    if time > 0
      return Timer.convert_time(time/60)["hours_and_minutes"]
    else
      return ""
    end
  end
  
  def flatrate_time_helper(job)
    if job.flatrate_time
      time = job.flatrate_time.to_f
      return Timer.convert_time(time)["hours_and_minutes"]
    else
      return ""
    end
  end
  
  def extra_time_helper(job)
    if job.extra_time
      time = job.extra_time.to_f
      return Timer.convert_time(time)["hours_and_minutes"]
    else
      return ""
    end
  end

  def difference_time_helper(job)
    recorded_time = 0
    job.timers.each do |timer|
      recorded_time += timer.interval
    end
    if job.flatrate_time
      difference = (recorded_time/60) - (job.flatrate_time.to_i + job.extra_time.to_i)
      if Timer.convert_time(difference)["positive"]
        Timer.convert_time(difference)["hours_and_minutes"]
      else
        "-"+Timer.convert_time(difference)["hours_and_minutes"]
      end
    else
      return ""
    end
  end
  
  def flatrate_time_hours_helper(job)
    if job.flatrate_time
      time = job.flatrate_time.to_f
      return Timer.convert_time(time)["hours"]
    else
      return "0"
    end
  end
  
  def flatrate_time_minutes_helper(job)
    if job.flatrate_time
      time = job.flatrate_time.to_f
      return Timer.convert_time(time)["minutes"]
    else
      return "0"
    end
  end
  
  def extra_time_hours_helper(job)
    if job.extra_time
      time = job.flatrate_time.to_f
      return Timer.convert_time(time)["hours"]
    else
      return "0"
    end
  end
  
  def extra_time_minutes_helper(job)
    if job.extra_time
      time = job.flatrate_time.to_f
      return Timer.convert_time(time)["minutes"]
    else
      return "0"
    end
  end
  
  def show_edit_helper(job)
    job.flatrate_time ? "" : "/edit"
  end
  
  
end

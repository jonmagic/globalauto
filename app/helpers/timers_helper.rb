module TimersHelper
  def running_image_helper(job)
    if job.status == "Running"
      image_tag '/images/play.png'
    else
      image_tag '/images/stop.png'
    end
  end
end

module TimersHelper
  def running_image_helper(job)
    if job.status == "Running"
      image_tag '/images/icons/control_play_blue.png'
    else
      image_tag '/images/icons/control_stop.png'
    end
  end
end

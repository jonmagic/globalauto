module JobsHelper
  def has_jobs(technician)
    if technician.has_jobs?
      return ""
    else
      return " new"
    end
  end
  
  def has_jobs_link_helper(technician)
    if technician.has_jobs?
      return "/technicians/#{technician.id}/jobs"
    else
      return "/technicians/#{technician.id}/jobs/new"
    end
  end
  
end

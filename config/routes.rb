ActionController::Routing::Routes.draw do |map|

  map.find_next_completed_record "/admin/jobs/next_job", :controller => 'admin/jobs', :action => 'find_next_completed_job'
  map.admin "/admin", :controller => 'admin/settings', :action => 'index'
  map.report_recorded_vs_flatrate "/admin/reports/recorded_vs_flatrate", :controller => 'admin/reports', :action => 'recorded_vs_flatrate'
  map.report_time_sheet "/admin/reports/time_sheet", :controller => 'admin/reports', :action => 'time_sheet'
  map.resources :timers
  
  map.job_arrived   '/jobs/:id/arrived',  :controller => 'jobs', :action => 'arrived'
  map.job_noshow    '/jobs/:id/no_show',  :controller => 'jobs', :action => 'no_show'
  map.job_toggle    '/jobs/:id/toggle',   :controller => 'jobs', :action => 'toggle'
  map.job_complete  '/jobs/:id/complete', :controller => 'jobs', :action => 'complete'
  map.resources :jobs
  map.resources :schedule do |day|
    day.resources :jobs
  end
  map.resources :technicians do |technician|
    technician.resources :jobs
    technician.resources :schedule do |day|
      day.resources :jobs
    end
  end
  map.resources :jobs do |job|
    job.resources :timers
  end
  map.resources :notes

  map.namespace(:admin) do |admin|
    admin.resources :technicians
    admin.resources :settings
    admin.resources :reports
    admin.resources :jobs
    admin.delete_jobs 'delete_jobs', :controller => 'jobs', :action => 'delete_jobs'
  end
    
  map.root :controller => 'schedule', :action => 'index'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

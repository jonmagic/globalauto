ActionController::Routing::Routes.draw do |map|

  map.find_next_completed_record "/admin/jobs/next_job", :controller => 'admin/jobs', :action => 'find_next_completed_job'
  map.admin "/admin", :controller => 'admin/settings', :action => 'index'
  map.timers "/timers", :controller => 'jobs', :action => 'timers'
  map.report_recorded_vs_flatrate "/admin/reports/recorded_vs_flatrate", :controller => 'admin/reports', :action => 'recorded_vs_flatrate'
  
  map.resources :jobs
  map.resources :technicians do |technician|
    technician.resources :jobs
  end
  map.resources :jobs do |job|
    job.resources :timers
  end
  map.resources :timers
  
  map.namespace(:admin) do |admin|
    admin.resources :technicians
    admin.resources :settings
    admin.resources :reports
    admin.resources :jobs
  end
    
  map.root :controller => 'jobs', :action => 'index'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

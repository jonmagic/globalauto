ActionController::Routing::Routes.draw do |map|
  map.resources :jobs
  map.resources :technicians do |technician|
    technician.resources :jobs
  end
  map.resources :jobs do |job|
    job.resources :timeclocks
  end
  map.resources :timeclocks
  map.resources :technicians
  map.resources :settings
  map.resources :sample
  
  map.redirect '/technicians/:technician_id/redirect', :controller => 'jobs', :action => 'redirect'
  
  map.root :controller => 'jobs', :action => 'index'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

ActionController::Routing::Routes.draw do |map|
  
  map.resources :sample
  
  map.root :controller => 'sample', :action => 'index'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

class SampleController < ApplicationController
  before_filter :login_required
  layout "application"
  
  def index
    
  end
end
class TechniciansController < ApplicationController
  before_filter :login_required, :except => ['index']
  
  def index
    redirect_to "/admin/technicians"
  end
end

class TechniciansController < ApplicationController
  before_filter :login_required
  
  def index
    @technicians = Technician.active_techs
  end
  
  def new
    @technician = Technician.new
  end
  
  def create
    @technician = Technician.new(params[:technician])
    if @technician.save
      flash[:notice] = "Successfully created technician."
      redirect_to url_for(@technician)
    else
      flash[:warning] = "Failed to create technician."
      redirect_to :back
    end
  end
  
  def edit
    @technician = Technician.find(params[:id])
  end
  
  def update
    @technician = Technician.find(params[:id])
    if @technician.update_attributes(params[:technician])
      flash[:notice] = "Successfully updated technician."
      redirect_to url_for(@technician)
    else
      flash[:warning] = "Failed to update technician."
      redirect_to :back
    end
  end
  
end

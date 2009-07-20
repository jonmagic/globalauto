class TimersController < ApplicationController
  
  def index
    @jobs = Job.active_jobs
  end
  
  def create
    @timer = Timer.new(params[:timer])

    if @timer.save
      render :nothing => true, :layout => false, :response => 200
    else
      render :nothing => true, :layout => false, :response => 500
    end
  end
  
  def update
    @timer = Timer.find(params[:id])

    if @timer.update_attributes(params[:timer])
      render :nothing => true, :layout => false, :response => 200
    else
      render :nothing => true, :layout => false, :response => 500
    end
  end

end
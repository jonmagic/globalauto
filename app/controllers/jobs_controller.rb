class JobsController < ApplicationController
  layout nil

  def index
    conditions = {}
    if params[:schedule_id]
      beginning_of_day = (params["schedule_id"][4..7]+"-"+params["schedule_id"][0..1]+"-"+params["schedule_id"][2..3]).to_date.beginning_of_day
      conditions[:scheduled_at] = { '$gt' => beginning_of_day - 24.hours, '$lt' => beginning_of_day+23.99.hours + 24.hours }
    end
    conditions[:technician_id] = params[:technician_id] if params[:technician_id]
    @jobs = Job.where(conditions).sort(:scheduled_at.asc).all
    render :json => @jobs.to_json(:methods => [:intersection])
  end

  def show
    @job = Job.find(params[:id])
  end

  def new
    @job = Job.new
    @technician = Technician.find(params[:technician_id])
  end

  def create
    @job = Job.new(params[:job])
    @job.technician_id = params[:technician_id]
    if @job.save
      render :nothing => true, :layout => false, :response => 200
    else
      render :json => @job.errors.to_json, :layout => false, :response => 500
    end
  end

  def edit
    @job = Job.find(params[:id])
    @technicians = Technician.all(:destroyed_at => nil)
  end

  def update
    @job = Job.find(params[:id])
    if @job.update_attributes(params[:job])
      render :nothing => true, :layout => false, :response => 200
    else
      render :nothing => true, :layout => false, :response => 500
    end
  end

  def arrived
    @job = Job.find(params[:id])
    @job.arrived
    render :nothing => true, :layout => false, :response => 200
  end
  
  def no_show
    @job = Job.find(params[:id])
    @job.no_show
    render :nothing => true, :layout => false, :response => 200
  end
  
  def toggle
    @job = Job.find(params[:id])
    @job.toggle
    render :nothing => true, :layout => false, :response => 200
  end
  
  def complete
    @job = Job.find(params[:id])
    @job.complete
    render :nothing => true, :layout => false, :response => 200
  end
  
  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    redirect_to :back
  end
end

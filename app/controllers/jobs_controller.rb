class JobsController < ApplicationController
  layout nil

  def index
    conditions = {}
    if params[:schedule_id]
      beginning_of_day = (params["schedule_id"][0..1]+"/"+params["schedule_id"][2..3]+"/"+params["schedule_id"][4..7]).to_date.beginning_of_day
      conditions[:scheduled_at] = { '$gt' => beginning_of_day, '$lt' => beginning_of_day+23.99.hours }
    end
    conditions[:technician_id] = params[:technician_id] if params[:technician_id]
    @jobs = Job.all(conditions.merge(:completed_at => nil))
    render :json => @jobs.to_json
  end

  def show

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
      render :nothing => true, :layout => false, :response => 500
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

  def destroy

  end
end

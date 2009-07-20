class JobsController < ApplicationController
  layout 'jobs'
  
  def index
    if params[:technician_id]
      @technician = Technician.find(params[:technician_id])
      @jobs = @technician.open_jobs

      respond_to do |format|
        format.html { render :layout => false }
        format.xml  { render :xml => @jobs }
      end      
    else
      @jobs = Job.active_jobs
      @technicians = Technician.active_techs

      respond_to do |format|
        format.html
        format.xml  { render :xml => @jobs }
      end
    end
  end
  
  def show
    @job = Job.find(params[:id])
    if @timer = Timer.last(:conditions => {:job_id => @job.id, :end_time => nil})
      @timer
    else
      @timer = Timer.new
    end

    respond_to do |format|
      format.html { render :layout => false }
      format.xml  { render :xml => @job }
    end
  end

  def new
    @technician = Technician.find(params[:technician_id])
    @job = Job.new

    respond_to do |format|
      format.html { render :layout => false }
      format.xml  { render :xml => @job }
    end
  end
  
  def edit
    @job = Job.find(params[:id])
    
    respond_to do |format|
      format.html { render :layout => false }
      format.xml  { render :xml => @job }
    end
  end

  def create
    @job = Job.new(params[:job])

    respond_to do |format|
      if @job.save
        flash[:notice] = 'Job was successfully created.'
        format.html { redirect_to "/" }
        format.xml  { render :xml => @job, :status => :created, :location => @job }
      else
        format.html { redirect_to "/" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @job = Job.find(params[:id])
    if params[:completed]
      if params[:time_spent]
        @job.recorded_time = params[:time_spent]
      else
        @job.recorded_time = @job.recorded_time_helper
      end
      @job.completed = Time.now
      @job.save
    end

    respond_to do |format|
      if @job.update_attributes(params[:job])
        format.html { redirect_to "/" }
        format.xml  { head :ok }
      else
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to(jobs_url) }
      format.xml  { head :ok }
    end
  end
end
